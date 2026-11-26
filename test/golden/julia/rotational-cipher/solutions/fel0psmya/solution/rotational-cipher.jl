function rotate(shift::Int, c::Char)
    shift = mod(shift, 26)

    if 'a' <= c <= 'z'
        return Char(mod(Int(c) - Int('a') + shift, 26) + Int('a'))
    elseif 'A' <= c <= 'Z'
        return Char(mod(Int(c) - Int('A') + shift, 26) + Int('A'))
    else
        return c
    end
end

function rotate(shift::Int, text::AbstractString)
    result = IOBuffer()
    for c in text
        print(result, rotate(shift, c))  # chama a versão para Char
    end
    return String(take!(result))
end
