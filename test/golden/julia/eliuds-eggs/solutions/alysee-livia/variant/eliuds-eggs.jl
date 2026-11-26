function eggcount(number)
    bin = string(number, base=3)
    @show bin
    eggs = collect(bin)
    @show eggs
    @show amount = count(==('1'), eggs)
    return  amount
    

end
