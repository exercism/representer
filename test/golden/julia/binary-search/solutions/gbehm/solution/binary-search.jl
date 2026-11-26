
function binarysearch(items, key; by = nothing, lt = nothing, rev = false)
    # process keyword arguments
    if !isnothing(by)
        # transform items and key
        items = map(by, items)
        key = by(key)
    end
    if isnothing(lt)
        lt = <
    end
    lo, hi = 1, lastindex(items)
    while lo <= hi
        mid = (lo + hi) ÷ 2
        if key == items[mid]
            result = keymatch(items, key, mid)
            lo, hi = result.start, result.stop
            return lo:hi
        end
        if (lt(key, items[mid]) && !rev) || (!lt(key, items[mid]) && rev)
            hi = mid - 1
        else
            lo = mid + 1
        end
    end
    return lo:hi
end

function keymatch(items, key, mid)
    lo = hi = mid
    if mid > 1 && items[mid - 1] == key
        lo = binarysearch(items[1:mid - 1], key).start
    end
    if mid < lastindex(items) && items[mid + 1] == key
        hi = mid + binarysearch(items[mid + 1:end], key).stop
    end
    return lo:hi
end
