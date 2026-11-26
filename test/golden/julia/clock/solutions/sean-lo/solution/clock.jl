using Printf

struct Clock
    hours::Integer
    minutes::Integer
    function Clock(hours::Integer, minutes::Integer)
        (q, minutes) = divrem(minutes, 60)
        if minutes < 0
            minutes += 60
            q -= 1
        end
        hours += q

        hours = hours % 24
        if hours < 0
            hours += 24
        end
        new(hours, minutes)
    end
end

function Base.:+(c::Clock, m::Minute)
    Clock(c.hours, c.minutes + Dates.value(m))
end
function Base.:-(c::Clock, m::Minute)
    Clock(c.hours, c.minutes - Dates.value(m))
end
function Base.:(==)(x::Clock, y::Clock)
    isequal(x.hours, y.hours) && isequal(x.minutes, y.minutes)
end
function Base.:(!=)(x::Clock, y::Clock)
    !isequal(x.hours, y.hours) || !isequal(x.minutes, y.minutes)
end

function Base.show(io::IO, c::Clock)
    @printf(io, "\"%02u:%02u\"", c.hours, c.minutes)
end