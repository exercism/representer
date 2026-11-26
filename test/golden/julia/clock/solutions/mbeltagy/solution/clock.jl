using Dates 

struct Clock 
    h::UInt8
    m::UInt8
    function Clock(h::Integer, m::Integer)
        if abs(m) ≥ 60
            h += m ÷ 60 
        end
        m = m % 60
        h -= m ≥ 0 ? 0 : 1
        if m < 0 m += 60 end    
        h = h % 24
        if h < 0 h += 24 end    
        new(h, m)
    end
end

import Base: -, ==, +

==(a::Clock, b::Clock) = (a.h == b.h) && (a.m == b.m)

-(a::Clock, m::Minute) = Clock(a.h, a.m - m.value)

+(a::Clock, m::Minute) = Clock(a.h, a.m + m.value)

Base.show(io::IO, c::Clock) = Base.show(io, lpad(c.h, 2, '0')*":"*lpad(c.m, 2, '0'))