#Gram-Schmidt Orthogonalization

function normalized_orthogonal_projection(b,Z::AbstractArray)
    annihilator =  I - Z * inv(Z'*Z) *Z'
    projection = annihilator*b
    return projection / norm(projection)
end

function gram_schmidt(x::AbstractArray)

    U = similar(x,Float64)

    for col in 1:size(U,2)
        b = X[:,col]       # vector we're going to project
        Z = X[:,1:col - 1] # first i-1 columns of X
        U[:,col] = normalized_orthogonal_projection(b, Z)
   end
   return U
end

y = [1, 3, -3]
X = [1 0; 0 -6; 2 2];

Py1 = X * inv(X'X) * X' * y #ordinary projection

U = gram_schmidt(X) #construct orthogonal set

Py2 = U*U'*y #use orthonormal projection result


#perform the same projection using QR decomposition
Q, R = qr(X)
Q = Matrix(Q)
R = Matrix(R)

Py3 = Q*Q'*y # Q is formed of columns from orthonormal basis of x
beta = inv(R)*Q'*y
