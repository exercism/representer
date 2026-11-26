function isisogram(word::String)::Bool
    used = Set()
    for c in lowercase(word)
        if !(('A' <= c <= 'Z') || ('a' <= c <= 'z')) continue end
        if c in used return false else push!(used, c) end
    end
    return true
end