local function can_chain(dominoes, ends)
    if #dominoes == 0 then
        return not ends or ends[1] == ends[2]
    end
    if not ends then
        return can_chain(dominoes, table.remove(dominoes))
    end
    for i = 1, #dominoes do
        local dom = table.remove(dominoes, i)
        if
            dom[1] == ends[1] and can_chain(dominoes, { dom[2], ends[2] })
            or dom[2] == ends[1] and can_chain(dominoes, { dom[1], ends[2] })
            or dom[1] == ends[2] and can_chain(dominoes, { ends[1], dom[2] })
            or dom[2] == ends[2] and can_chain(dominoes, { ends[1], dom[1] })
        then
            return true
        end
        table.insert(dominoes, i, dom)
    end
    return false
end

return { can_chain = can_chain }
