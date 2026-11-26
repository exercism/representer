function spiral_matrix(n)
    nrows = n; ncols = n
    s = Matrix{Int}(undef, n, n)
    
    n > 0 || return s
    
    a = 1
    r = 1
    c = 1
    s[1,1] = 1

    while nrows > 0
        while c < ncols
            a +=1; c+=1
            s[r, c] = a
        end

        while r < nrows
            a +=1; r+=1
            s[r, c] = a
        end
        nrows-=1
        ncols-=1

        while c > n - ncols
            a +=1; c-=1
            s[r,c] = a
        end

        while r > n - nrows-1
            a += 1; r-=1
            s[r,c] = a
        end
    end
    
    return s
end