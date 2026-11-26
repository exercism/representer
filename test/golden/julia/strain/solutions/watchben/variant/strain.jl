function keep(values, predicate)
    return map(predicate,values)
end

function discard(values, predicate)
    return filter(!predicate,values)
end
