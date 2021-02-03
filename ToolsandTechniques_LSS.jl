using InstantiateFromURL
# optionally add arguments to force installation: instantiate = true, precompile = true
github_project("QuantEcon/quantecon-notebooks-julia", version = "0.8.0")

using LinearAlgebra, Statistics
using QuantEcon, Plots
gr(fmt=:png);

# Exercise 1
ϕ_0, ϕ_1, ϕ_2 = 1.1, 0.8, -0.8

A = [1.0 0.0 0.0; ϕ_0 ϕ_1 ϕ_2; 0.0 1.0 0.0]
C = zeros(3,1)
G = [0 1 0]
μ_0 =  ones(3)

lss = LSS(A,C,G; mu_0 = μ_0)

x,y = simulate(lss, 50)
plot(dropdims(y, dims = 1), color = :blue)
plot!(xlabel="time", ylabel = "y_t", legend = :none)

# Exercise 2

using Random
Random.seed!(42) # For deterministic results.

ϕ1, ϕ2, ϕ3, ϕ4 = 0.5, -0.2, 0, 0.5
σ = 0.2

A = [ϕ1 ϕ2 ϕ3 ϕ4; 1.0 0.0 0.0 0.0; 0.0 1.0 0.0 0.0; 0.0 0.0 1.0 0.0]
C = [σ; 0.0; 0.0; 0.0]
G = [1.0 0.0 0.0 0.0]
μ_0 =  ones(4)

lss = LSS(A,C,G; mu_0 = μ_0)

x,y = simulate(lss, 200)
plot(dropdims(y, dims = 1), color = :blue)
plot!(xlabel="time", ylabel = "y_t", legend = :none)

# Exercise 3
ϕ1, ϕ2, ϕ3, ϕ4 = 0.5, -0.2, 0, 0.5
σ = 0.1

A = [ϕ1 ϕ2 ϕ3 ϕ4; 1.0 0.0 0.0 0.0; 0.0 1.0 0.0 0.0; 0.0 0.0 1.0 0.0]
C = [σ; 0.0; 0.0; 0.0]
G = [1.0 0.0 0.0 0.0]
μ_0 = ones(4)

I = 20
T = 50

ar = LSS(A, C, G; mu_0 = μ_0)

ensemble_mean = zeros(T)
ys = []
for ii in 1:I
        x,y = simulate(ar, T)
        y = dropdims(y, dims=1)
        push!(ys,y)
        ensemble_mean .+= y
end
ensemble_mean = ensemble_mean./I

plot(ensemble_mean, label = "y_t_bar", linewidth = 2)
plot!(ys, linewidth = 0.8, alpha = 0.2, label = "", color =:blue)

ymin, ymax = -0.5, 1.15
m = moment_sequence(ar)
pop_means = zeros(0)
for (i, t) ∈ enumerate(m)
    (μ_x, μ_y, Σ_x, Σ_y) = t
    push!(pop_means, μ_y[1])
end
plot!(pop_means, color = :green, linewidth = 2, label = "G mu_t")
plot!(ylims=(ymin, ymax), xlabel = "time", ylabel = "y_t", legendfont = font(12))
