import Base
import Dates
import Printf

struct Clock
    minutes
    Clock(m) = new((m % (24 * 60) + 24 * 60) % (24 * 60))
end

Clock(hours, minutes) = Clock(hours * 60 + minutes)

Base.:+(clock::Clock, shift::Dates.Minute) = Clock(clock.minutes + shift.value)
Base.:-(clock::Clock, shift::Dates.Minute) = Clock(clock.minutes - shift.value)
Base.show(io::IO, clock::Clock) = Printf.@printf io "\"%02d:%02d\"" (clock.minutes ÷ 60) (clock.minutes % 60)
