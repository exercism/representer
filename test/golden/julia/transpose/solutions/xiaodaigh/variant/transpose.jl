function transpose_strings(input)
    # special case
    if length(input) == 0
        return input
    end
    # make a matrix to keep track of stuff
    # TODO this can be skipped to save memory
    m = Matrix{Union{Char, Missing}}(missing, length(input), maximum(length, input))
    for (row, string) in enumerate(input)
        for (col, char) in enumerate(collect(string))
            m[row, col] = char
            # padding
            for r in row+1:-1:1
                if ismissing(m[r, col])
                    m[r, col] = ' '
                end
            end
        end
    end
    res = [String([c for c in col if !ismissing(c)]) for col in eachcol(m)]
end

