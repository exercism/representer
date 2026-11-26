# Change any of the following NamedTuple values to true to 
# enable testing different bonus tasks
tested_benus_tasks = (rev = true, by = false, lt = true, multiple_matches = true)

function recursive_search(sorted, target, start, finish; rev = false, lt = (<))
    if start > finish
        return start:finish
    end
    mid=Int64(round((start+finish)/2))
    if sorted[mid] == target
        start = mid
        finish = mid
        while ( start > 1 && sorted[start-1] == target )
            start = start - 1
        end
        while ( finish < length(sorted) && sorted[finish+1] == target)
            finish = finish + 1
        end
        return start:finish
    elseif lt(sorted[mid], target) == !rev
        return recursive_search(sorted, target, mid + 1, finish; rev, lt)
    else
        return recursive_search(sorted, target, 1, mid - 1; rev, lt)
    end
end

function binarysearch(sorted, target; rev = false, lt = (<))
    return recursive_search(sorted, target, 1, length(sorted); rev, lt)
end

