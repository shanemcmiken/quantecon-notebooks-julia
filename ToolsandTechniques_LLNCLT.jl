using InstantiateFromURL
# optionally add arguments to force installation: instantiate = true, precompile = true
github_project("QuantEcon/quantecon-notebooks-julia", version = "0.8.0")

using LinearAlgebra, Statistics
using Plots, Distributions, Random, Statistics
gr(fmt = :png, size = (900, 500))

function ksl(distribution, n = 100)
    title = nameof(typeof(distribution))
    observations = rand(distribution, n)
    sample_means = cumsum(observations) ./ (1:n)
    μ = mean(distribution)
    plot(repeat((1:n)', 2),
         [zeros(1, n); observations'], label = "", color = :grey, alpha = 0.5)
    plot!(1:n, observations, color = :grey, markershape = :circle,
          alpha = 0.5, label = "", linewidth = 0)
    hline!([μ], color = :black, linewidth = 1.5, linestyle = :dash, grid = false, label = ["Mean"])
    plot!(1:n, sample_means, linewidth = 3, alpha = 0.6, color = :green,
          label = "Sample mean")
    return plot!(title = title)
end

# Example distributions
distributions = [TDist(10), Beta(2,2), Gamma(5,2), Poisson(4), LogNormal(0.5), Exponential(1)]

Random.seed!(0); #reproducible results
ksl(Normal())
plot(ksl.(sample(distributions, 3, replace = false))..., layout = (3, 1), legend = false)

# Cauchy distribution may not converge as E|X| < ∞ not satisfied (heavy tailed)


function plotmeans(distribution::Distribution{Univariate,Continuous};n=1000)
    sample_mean  = cumsum(rand(distribution,n)) ./ (1:n)
    plot(1:n, sample_mean, label = "sample mean")
    hline!([0], color = :black, linestyle = :dash)
end

Random.seed!(0);
plotmeans(Cauchy(),n=10000)


using StatsPlots

function simulation1(distribution::Distribution{Univariate,Continuous}; n=250, k = 10_000)
    σ = std(distribution)
    y = rand(distribution,n,k)
    y .-= mean(distribution)
    y = mean(y,dims=1)
    y = √n *vec(y)
    density(y,label = "Empirical Distribution")
    return plot!(Normal(0,σ), linestyle = :dash, label = "Normal(0.0, $(σ^2))")
end

Random.seed!(0);
simulation1(Exponential(0.5), n=100)

function simulation2(distribution = Beta(2, 2), n = 5, k = 10_000)
    y = rand(distribution, k, n)
    for col in 1:n
        y[:,col] += rand([-0.5, 0.6, -1.1], k)
    end
    y = (y .- mean(distribution)) ./ std(distribution)
    y = cumsum(y, dims = 2) ./ sqrt.(1:5)' # return grid of data
end

ys = simulation2()
plots = [] # would preallocate in optimized code
for i in 1:size(ys, 2)
    p = density(ys[:, i], linealpha = i, title = "n = $i")
    push!(plots, p)
end

plot(plots..., legend = false)

# Exercise 1

function exercise1(a,b; g = sin, g′ = cos, n=250, k=10_000)
    distribution = Uniform(a,b)
    μ, σ = mean(distribution), std(distribution)
    gμ = sin.(mean(distribution))
    X = rand(distribution,n,k)
    X = mean(X, dims = 1)
    X = vec(X)
    y = √n .* vec(g.(X) .- g.(μ))
    density(y,label = "Empirical Distribution")
    return plot!(Normal(0,g′(μ).*σ), linestyle = :dash, label = "Asymptotic")
end

exercise1(0.0,π/2,k=15000)


# Exercise 2
function exercise2(;n = 250, k = 50_000, dw = Uniform(-1, 1), du = Uniform(-2, 2))
    vw = var(dw)
    vu = var(du)
    Σ = [vw vw; vw vu+vw]
    Q = inv(sqrt(Σ))

    function generate_data(dw, du, n)
        dw = rand(dw, n)
        X = [dw dw + rand(du, n)]
        return sqrt(n) * mean(X, dims = 1)
    end

    X = mapreduce(x -> generate_data(dw, du, n), vcat, 1:k)
    X = sqrt(n) .* mean(X, dims=1)
    X = Q*X'
    X = sum(abs2, X, dims = 1)
    X = vec(X)
    density(X, label = "", xlim = (0, 10))
    return plot!(Chisq(2), color = :black, linestyle = :dash,
                 label = "Chi-squared with 2 degrees of freedom", grid = false)
end
exercise2()
