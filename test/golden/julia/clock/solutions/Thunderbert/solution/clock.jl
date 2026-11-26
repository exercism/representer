using Dates
import Base: +
import Base: -
import Base: show

struct Clock
    h::Int
    m::Int
    function Clock(h::Int, m::Int)
        newm = m + h * 60
        newh = (newm ÷ 60) % 24
        newm = newm % 60
        if newm < 0
            newm = 60 + newm
            newh -= 1
        end
        newh < 0 && (newh = 24 + newh)
        new(newh, newm)
    end
end

function +(t::Clock, m::Minute)
    return Clock(t.h, t.m + m.value)
end

function -(t::Clock, m::Minute)
    return Clock(t.h, t.m - m.value)
end

function show(io::IO, t::Clock)
    print(io, "\"" * lpad(t.h, 2, "0") * ":" * lpad(t.m, 2, "0") * "\"")
end