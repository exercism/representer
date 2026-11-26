import Base: +, -
import Dates

struct Clock
    minutes::Int

    function Clock(m)
        minutes = mod(m,  1440)
        new(minutes)
    end

    function Clock(h, m)
        Clock(h * 60 + m)
    end
end

+(c::Clock, m::Dates.Minute) = Clock(c.minutes + m.value)

-(c::Clock, m::Dates.Minute) = c + (-m)

show(io::IO, c::Clock) = print(io, "\"" * lpad(c.minutes÷60, 2, "0") * ":" * lpad(c.minutes%60, 2, "0") * "\"")
