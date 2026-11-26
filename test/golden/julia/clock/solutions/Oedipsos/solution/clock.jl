using Printf: @sprintf
using Dates

struct Clock
    hour::Int8
    minute::Int8

    Clock(h=0, m=0) = Clock(h, m)
    Clock(h, m) = new(mod(h + fld(m, 60), 24), mod(m, 60))
end

Base.show(io::IO, c::Clock) = Base.show(io, @sprintf "%02d:%02d" c.hour c.minute)
Base.:+(c::Clock, m::Minute) = Clock(c.hour, c.minute + m.value)
Base.:-(c::Clock, m::Minute) = Clock(c.hour, c.minute - m.value)
