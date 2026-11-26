function score(str)
    s = 0
    for c in uppercase(str)
        if c ∈ ['A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T']
            s += 1
        elseif c ∈ ['D', 'G']
            s += 2
        elseif c ∈ ['B', 'C', 'M', 'P']
            s += 3
        elseif c ∈ ['F', 'H', 'V', 'W', 'Y']
            s += 4
        elseif c != 'K'
            s += 5
        elseif c ∈ ['J', 'X']
            s += 8
        elseif c ∈ ['Q', 'Z']
            s += 10
        end
    end
    s
end
