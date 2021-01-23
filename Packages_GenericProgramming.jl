# Exercise 1a
using LinearAlgebra


function trap_weights(x)
    return step(x) * [0.5; ones(length(x) - 2); 0.5]
end
x = range(0.0, 1.0, length = 10)
ω = trap_weights(x)
f(x) = x^2
dot(f.(x), ω)

struct UniformTrapezoidal
    count::Int
    Δ::Float64
end

Base.iterate(S::UniformTrapezoidal, state=1) = state > S.count ? nothing : (if state == 1 || state == count; Δ*0.5 else Δ*1.0 end, state+1)

function integration(f, x::AbstractArray; count = 10)
    Δ = step(x)
    int = similar(x)
    for (i,value) in enumerate(UniformTrapezoidal(count,Δ))
        int[i] = f(x[i]) * value
    end
    return sum(int)
end

count = 100
x = range(0.0, 1.0, length = count)
@show Δ = step(x)
f(x) = x^2

integral = integration(f,x,count = count)


struct Squares
    count::Int
end

Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)

for i in Squares(7)
    println(i)
end

struct SquaresVector <: AbstractArray{Int, 1}
    count::Int
end
Base.size(S::SquaresVector) = (S.count,)
Base.IndexStyle(::Type{<:SquaresVector}) = IndexLinear()
Base.getindex(S::SquaresVector, i::Int) = i*i

s = SquaresVector(4)
s[2]


# Exercise 1b

struct TrapezoidalVector <: AbstractArray{Int, 1}
    count::Int
end
Base.size(S::TrapezoidalVector) = (S.count,)
Base.IndexStyle(::Type{<:TrapezoidalVector}) = IndexLinear()
Base.getindex(S::TrapezoidalVector, i::Int) = 1
Base.setindex!(S::TrapezoidalVector, v, 2) = 2


V = TrapezoidalVector(4)
