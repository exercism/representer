using Dates

struct Clock
    time::Dates.Time
    function Clock(hraw::Int, mraw::Int)
        m = mod(mraw, 60)
        q = div(mraw - m, 60)
        h = mod(hraw + q, 24)
        new(Time(h, m))
    end
    Clock(t::Time) = new(t)
end

import Base.(+), Base.(-), Base.show
(+)(c::Clock, m::Dates.Minute) = Clock(c.time + m)
(-)(c::Clock, m::Dates.Minute) = Clock(c.time - m)
show(io::IO, c::Clock) = show(io, Dates.format(c.time, "HH:MM"))