function binarysearch(x, v; by=x->x, lt=<, rev=false)
    i = 1
    j = length(x)
    v = by(v)
    while i <= j
        k = (i + j) ÷ 2
        xk = by(x[k])
        if xk == v
            # match, but we must expand range to left and right
            i = k
            while i > 1
                xi = by(x[i - 1])
                if xi != v
                    break
                end
                i -= 1
            end
            j = k
            while j < length(x)
                xj = by(x[j + 1])
                if xj != v
                    break
                end
                j += 1
            end
            break  # finish search
        elseif lt(xk, v)
            # select correct half of current interval
            if !rev
                i = k + 1
            else
                j = k - 1
            end
        else
            # select correct half of current interval
            if !rev
                j = k - 1
            else
                i = k + 1
            end
        end
    end
    return i:j
end
