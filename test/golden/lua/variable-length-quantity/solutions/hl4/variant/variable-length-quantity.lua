local function decode(bytes)
    assert(bytes[#bytes] < 128, 'incomplete byte sequence')
    local seq, hi = {}, 0
    for _, v in ipairs(bytes) do
        hi = hi << 7 | v & 0x7F
        if v <= 128 then
            table.insert(seq, hi)
            hi = 0
        end
    end
    
    return seq
end

local function encode(values)
    local bytes = {}
    for _, v in ipairs(values) do
        table.insert(bytes, v & 0x7F)
        v = v >> 7
        local pos = #bytes 
        while v > 0 do
            table.insert(bytes, pos, v & 0x7F | 0x80)
            v = v >> 7
        end
    end
    return bytes
end

return { decode = decode, encode = encode }
