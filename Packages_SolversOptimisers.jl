# Exercise 1
#various rules for differentiation


struct DualNumber{T} <: Real
    val::T
    ϵ::T
end
import Base: +, *, -, ^, /, exp
+(x::DualNumber, y::DualNumber) = DualNumber(x.val + y.val, x.ϵ + y.ϵ)  # dual addition
+(x::DualNumber, a::Number) = DualNumber(x.val + a, x.ϵ)  # i.e. scalar addition, not dual
+(a::Number, x::DualNumber) = DualNumber(x.val + a, x.ϵ)  # i.e. scalar addition, not dual
-(x::DualNumber, y::DualNumber) = DualNumber(x.val - y.val, x.ϵ - y.ϵ)  # dual subtraction
-(x::DualNumber, a::Number) = DualNumber(x.val - a, x.ϵ)  # i.e. scalar subtraction, not dual
-(a::Number, x::DualNumber) = DualNumber(x.val - a, x.ϵ)  # i.e. scalar subtraction, not dual
/(x::DualNumber, y::DualNumber) = DualNumber(x.val/y.val, (y.val*x.ϵ - x.val*y.ϵ)/y.val^2) #dual quotient rule
*(x::DualNumber, y::DualNumber) = DualNumber(x.val*y.val, x.val*y.ϵ + y.val*x.ϵ ) #dual product rule
*(x::DualNumber, a::Number) = DualNumber(a*x.val, a*x.ϵ ) #scalar multiplicaiton
^(a::Number, x::DualNumber) = DualNumber(x.val^a, a*x.val^(a-1)*x.ϵ)



f(x) = x^2.0

x = DualNumber(1.0, 1.0)  # x -> 2.0 + 1.0\epsilon
y = DualNumber(3.0, 1.0)  # i.e. y = 3.0, no derivative


# seeded calculates both the function and the d/dx gradient!
f(x)
