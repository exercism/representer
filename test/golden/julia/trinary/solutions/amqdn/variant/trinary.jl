function trinary_to_decimal(str)
    all(c ∈ "012" for c in str) || return 0  # stolen from gongzhaohui
    res = []
    for (i, d) in zip(0:length(str), reverse(str))
        push!(res, 3^i / parse(Int, d))
    end
    return sum(res)
end