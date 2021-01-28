using ExamplePackage
ExamplePackage.greet()

b = 1.0
function g(a)
    global b
    for i ∈ 1:1_000_000
        tmp = a + b
    end
end

using BenchmarkTools
@show @btime g(1.0) #globals are bad for memory allocation
#@show @code_native g(1.0)

#w/o globals

function f(a, b)
    for i ∈ 1:1_000_000
        tmp = a + b
    end
end

@btime f(1.0,1.0)

const b_const = 1.0
function g(a)
    global b_const
    for i ∈ 1:1_000_000
        tmp = a + b_const
    end
end


struct Foo_generic
    a
end

struct Foo_abstract
    a::Real
end

struct Foo_concrete{T<:Real}
    a::T
end

fg = Foo_generic(1.0)
fa = Foo_abstract(1.0)
fc = Foo_concrete(1.0)

function f(foo)
    for i ∈ 1:1_000_000
        tmp = i + foo.a
    end
end

@show @btime f($fc)
@code_native f(fc)
