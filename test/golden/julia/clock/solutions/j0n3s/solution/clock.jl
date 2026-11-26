import Dates
import Printf

const DAY = 24 * 60

struct Clock
    hour::Int
    minute::Int
    function Clock(h, m)
        timestamp = mod(h * 60 + m, 0:DAY-1)
        new(timestamp ÷ 60, timestamp % 60)
    end
end

Base.:+(c::Clock, duration::Dates.Minute) = offset(c, duration)
Base.:-(c::Clock, duration::Dates.Minute) = offset(c, -duration)
Base.:show(io::IO, clock::Clock) =
    print(io, Printf.@sprintf("\"%02d:%02d\"", clock.hour, clock.minute))

function offset(c::Clock, d::Dates.Minute)
    Clock(c.hour, c.minute + d.value)
end
