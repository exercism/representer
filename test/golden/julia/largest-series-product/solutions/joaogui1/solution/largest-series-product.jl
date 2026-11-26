function max_prod(v, span)
    candidate = 0
    for i in 1:length(v)-span+1
        candidate = max(candidate, prod(v[i:i+span-1]))
    end
    return candidate
end

function largest_product(str, span)
    if span > length(str) || span < 0
        throw(ArgumentError(""))
    end
    vec = map(c -> parse(Int, c), collect(str))
    max_prod(vec, span)
end
