
function pythagorean_triplets(N::Int64)::Vector{NTuple{3, Int64}}

    res = Vector{NTuple{3, Int64}}()
    for k in 1:40, n in 1:N÷k, m in n:N÷k
        a = k*(m^2 - n^2)
        b = k*(2*m*n)
        c = k*(m^2 + n^2)
        if a + b + c == N && a != 0
            if a > b push!(res, (b,a,c))
            else push!(res, (a,b,c))
            end
        end
    end
    sort(unique(res))
end