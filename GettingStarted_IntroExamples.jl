# Exercise 1

function factorial2(n)
    k=1
    for i ∈ 1:n
        k = k * i
    end
    return k
end

factorial2(3)


# Exercise 2

function binomial_rv(n,p)
    count = 0
    U = rand(n)
    for i ∈ 1:n
        if U[i] < p
            count += 1
        end
    end
    return count
end

n=60
p=0.7

binomial_rv(n,p)


# Exercise 3

n = 10000
count = 0

for i ∈ 1:n
    x, y = rand(2)
    r = ((x-0.5)^2 + (y-0.5)^2)^(0.5) # distance from center of circle
    if r < 0.5 # radius
        count+=1
    end
end

pi_estimate = (count/n)/0.5^2

println("Estimated pi = $pi_estimate")

# Exercise 4

function flipcoin(n)
    payoff = 0
    count = 0
    x = rand(n)
    for i ∈ eachindex(x)
        if x[i] <= 0.5
            count += 1
        else
            count = 0
        end
        print(count)
        if count >= 3
            payoff = 1
        end
    end
    return (count,payoff)
end

# parameters
n = 10
flipcoin(n)

# Exercise 5

# parameters
n = 200
α = 0.9

x = zeros(n)

for i ∈ 1:n
    x[i+1] = α * x[i] + randn()
end
plot(x)


# Exercise 6

αs = [0.0, 0.8, 0.98]
n = 200
p = plot() # naming a plot to add to

for α in αs
    x = zeros(n + 1)
    x[1] = 0.0
    for t in 1:n
        x[t+1] = α * x[t] + randn()
    end
    plot!(p, x, label = "alpha = $α") # add to plot p
end
p # display plot


# Exercise 7
function firstpassage(threshold; tmax=100, α = 1.0, σ =0.2)
    x = zeros(tmax)
    x[1] = 1.0
    x[tmax] = 0.0
    for i in 2:tmax
        x[i] = α * x[i-1] + σ * randn()
        if x[i] < threshold # checks threshold
            return i # leaves function, returning draw number
        end
    end
    return tmax # if here, reached maxdraws
end

# parameters
tmax = 200
σ = 0.2
αs = [0.8, 1.0, 1.2]
threshold = 0.0

# sample using firstpassage
nsamp = 100
averages = zeros(0)

for α ∈ αs
    draws = zeros(nsamp)
    for i ∈ 1:100
        draws[i] = firstpassage(threshold, tmax=tmax, α = α, σ = σ)
    end
    average = mean(draws)
    push!(averages,average)
#    histogram!(h, draws, labels = "alpha = $α", bins= 20) # add to histogram h
end
averages
# h

# Exercise 8a

function f_prime(f; x0 = 2)

    # intialise loop
    crit = 1
    iter = 1
    del = 0.1
    normdiff = Inf

    fd_initial = (f(x0+del)-f(x0))/del
    fd_old = fd_initial

    while crit > 1.0E-8 && iter < 1000

        del = del/2 # shrink change
        fd_new = (f(x0+del)-f(x0))/del #calculate derivative

        crit =  norm(fd_new - fd_old) #how large is the change in derivative?

        # continuation
        iter = iter + 1
        fd_old = fd_new
    end
    return fd_old
end

# test with polynomial function
f(x) = (x-1)^3
x0 = 2

derivative = f_prime(f,x0=2)

# Newton Raphson algorithm

function NewtonRaphson(f, f_prime; x0 = 2, tolerance =1.0E-8 , maxiter = 1000)

    #initialise loop
    iter = 1
    normdiff = Inf

    x_old = x0 # starting point
    f_old = f(x0)

    while normdiff > tolerance && iter < maxiter

        fd = f_prime(f, x0 = x_old) # get derivative

        step = f(x_old)/fd # compute step

        x_new = x_old - step # compute expression to iterate over

        normdiff = norm(x_new - x_old)# do we converge?

        # continuation
        iter = iter+1
        x_old = x_new
    end
    return (root = x_old, normdiff = normdiff, iter = iter )
end

# peform Newton Raphson algorithm
f(x) = (x-1)^3
x0 = 2

sol = NewtonRaphson(f,f_prime, x0 = x0, tolerance =1.0E-8 , maxiter = 1000 )

println("root = $(sol.root), and |f(x) - x| = $(sol.normdiff) in $(sol.iter) iterations")
