return function(t, f)
    local new = {}
    for i,v in ipairs(t) do
        new[i] = f(v)
    end
    return new
end