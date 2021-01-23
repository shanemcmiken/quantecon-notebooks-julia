# Exercise 1

using LinearAlgebra, Statistics

function lyapunov(A,Σ; tolerance = 1.0E-8, maxiter = 500, S0 = Σ*Σ')

    #initialise loop
    normdiff = Inf
    iter = 1
    S_old = S0
    Q = Σ * Σ'

    while normdiff > tolerance && iter ≤ maxiter

        S_new = A * S_old * A' + Q

        #continue looping
        normdiff = norm(S_old - S_new)
        S_old = S_new
        iter = iter +1
    end
    return (S_old,iter)
end

# test function
A = [0.8  -0.2; -0.1  0.7]
Σ = [0.5 0.4; 0.4 0.6]

@show maximum(abs, eigvals(A))

our_solution, iter = lyapunov(A, Σ)

###############
# Exercise 2
###############
using Plots

Θ = [0.8, 0.9, 0.98] #parameters
γ = 1
σ = 1
T = 150 #horizon
p = plot() #naming plot to add
y0 = 1
τ = 5 # moving average - interval

for θ in Θ
    y = zeros(T+1)
    y[1] = y0
    for i ∈ 1:T
        y[i+1] = γ + θ * y[i] + σ * randn()
    end
    plot!(p, y, label = "θ = $θ")

    # moving average
    x = zeros(T+1)
    for i ∈ τ:(T+1)
        x[i]= sum(y[(i-τ+1):i])/τ
    end

    plot!(p, x, label = "rolling mean θ = $θ" )
end
p

# simulate "nsamp" times

function sim_randomwalk_drift(Θ,γ,σ,T)

    y_sim = zeros(nsamp,length(Θ))
    for j in 1:nsamp

        y = zeros(T+1,length(Θ))
        y[1,:] = ones(eltype(Θ), length(Θ))

        for i in 1:T
            y[i+1,:] = γ .+ Θ .*y[i,:] + σ.*randn(3)
        end

        y_sim[j,:] = y[T+1,:]
    end
    return y_sim
end

y_sim = sim_randomwalk_drift(Θ,γ,σ,T)

# find mean and variance of ensemble averages

@show (mean_θ1, mean_θ2, mean_θ3) = (mean(y_sim[:,1]),mean(y_sim[:,2]),mean(y_sim[:,3]))
@show (var_θ1, var_θ2, var_θ3) = (var(y_sim[:,1]),var(y_sim[:,2]),var(y_sim[:,3]))

# plot histogram of T+1 values

h=histogram()
for (i,θ) in enumerate(Θ)
    histogram!(h, y_sim[:,i],α =0.5, label = "θ = $θ",bins =20)
end
h

##############
# Exercise 3
##############


# simulate observations

N = 50 # number of observations

x_1, x_2 = (randn(N), randn(N))

a, b, c, d, σ = (0.1, 0.2, 0.5, 1.0, 0.1) #parameters

# simulate data

function simdata(a, b, c, d, σ, N; M = 20)
    y = zeros(N,M)
    for i in 1:N
        y[i,:] = a * x_1[i] + b * x_1[i]^2 + c * x_2[i] + d .+ σ.*randn(M)
    end
    return y
end

Y = simdata(a, b, c, d, σ, N)

# perform OLS

X = [x_1 x_1.^2 x_2 ones(N)]
β = zeros(M,size(X)[2])

for m in 1:M
    β[m,:] = inv(X'*X)*X'*Y[:,m]
end
β


# plot histograms
Θ = ["a=0.1" "b=0.2" "c=0.5" "d=1.0"]
h = histogram()

for (i,θ) in enumerate(Θ)
    histogram!(h, β[:,i],α = 0.8, label = θ, bins = 10)
end
h

############################
# Exercise 4 - use NL solve
############################

using NLsolve


A = [0.8  -0.2; -0.1  0.7]
Σ = [0.5 0.4; 0.4 0.6]
Q = Σ * Σ'
S0 = Σ * Σ'

f(S) = A * S * A' + Q

f(S0)
sol = fixedpoint(f,S0)
sol
