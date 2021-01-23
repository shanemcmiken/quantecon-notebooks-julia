# Exercise 1

using LinearAlgebra
using StaticArrays
using BenchmarkTools

N = 3
A = rand(N, N)
x = rand(N)

@btime $A * $x  # the $ in front of variable names is sometimes important
@btime inv($A)

# Benchmark

A_s = @SMatrix rand(N,N)
x_s =  @SVector rand(N)

@btime  $A_s * $x_s
@btime inv($A_s);

# very fast matrix multiplication, use $ and denote as static vectors
@btime $A_s * $x_s
@show supertypes(typeof(A_s))
@show supertypes(typeof(A));

# Exercise 2

Σ = [0.4  0.3;
     0.3  0.45]
G = I
R = 0.5 * Σ

gain(Σ, G, R) = Σ * G' * inv(G * Σ * G' + R)
@btime gain($Σ, $G, $R)

# Benchmark

Σ_s = @SMatrix [0.4  0.3; 0.3  0.45]
R_s = 0.5 * Σ_s

@show typeof(R) #static array, too

@btime gain($Σ_s, $G, $R_s);


# Exercise 3

using Polynomials

p = Polynomial([2, -5, 2], :x)  # :x just gives a symbol for display

@show p
@show typeof(p)
p′ = derivative(p)   # gives the derivative of p, another polynomial
@show p(0.1), p′(0.1)  # call like a function
@show roots(p);   # find roots such that p(x) = 0

# plot p and p'

r = range(-2.0, 2.0, length = 20)

p_r = p.(r)
p′_r = p′.(r)

plot(r[1:end-1],p′_r[1:end-1],label="Dp(x)")
plot!(r,p_r,label="p(x)")

# Exercise 4

function newtonsmethod(p::Polynomial, x_0; tolerance = 1E-7, maxiter = 100)

    p′ = derivative(p)

    #initialise loop
    iter = 1
    normdiff = Inf
    x_old = x_0

    while normdiff > tolerance && iter < maxiter

        x_new = x_old - p(x_old)/ p′(x_old)
        normdiff = norm(x_new - x_old)

        iter += 1 #continuation
        x_old = x_new
    end
    return (root = x_old, normdiff = normdiff, iter = iter )
end

# Compute roots

p = Polynomial([2, -5, 2], :x)  # :x just gives a symbol for display

@show newtonsmethod(p, 5);   # find roots such that p(x) = 0
@show roots(p)
@btime newtonsmethod(p, 5);
@btime roots(p);

# Exercise 5
function trapezoidal(f::AbstractArray{Float64,1}, x::AbstractArray{Float64,1})
    sol = similar(x)
    del = diff(x)
    for i in 2:length(x)
        sol[i] = (f_x[i]+f_x[i-1])/2*del[i-1]
    end
    return sum(sol)
end

x = range(0.0,1.0,length=9)
f(x) = x^2
f_x = f.(x)


int = trapezoidal(f_x,x)

function trapezoidal2(f::AbstractArray{Float64}, x::AbstractRange{Float64})
    sol = similar(x)
    del = step(x)
    for i in 2:length(x)
        sol[i] = (f_x[i]+ f_x[i-1])/2*del
    end
    return sum(sol)
end

x = range(0.0,1.0,length=1100)
f(x) = x^2
f_x = f.(x)

integral = trapezoidal2(f_x,x)

f(x) = x^3
x̄ = 1.0
x̲ = 0.0
N = 1100;

function trapezoidal3(f, x̲::Real , x̄::Real , N::Int64)
    x = range(x̲, x̄, length = N)
    f_x = f.(x)

    #implementation the same as trapezodal2
    sol = similar(x)
    del = step(x)
    for i in 2:length(x)
        sol[i] = (f_x[i]+ f_x[i-1])/2*del
    end
    return sum(sol)
end

integral = trapezoidal3(f ,x̲ , x̄ , N)

# Exercise 6

using ForwardDiff

function f(a, b; N::Int64 = 50)
    r = range(a, b, length=N) # one
return mean(r)
end

Df(x) = ForwardDiff.derivative(y -> f(0.0, y), x)

@show f(0.0, 3.0)
@show f(0.0, 3.1)

Df(3.0)

function f(a, b; N::Int64 = 50)
    r = range(a, b, length=N) # one
return mean(r)
end
