function isarmstrong(x)
    n = 0
    tmp = x
    anum=[]
    while tmp > 0
        n = n+1
        append!(anum, tmp%10)
        tmp = tmp ÷ 10
    end
    
    return length(anum) == 0 ? true : reduce(+, map(v -> v^n, anum)) == x
    
end