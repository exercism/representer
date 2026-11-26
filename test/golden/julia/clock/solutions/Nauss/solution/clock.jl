import Base.:+
import Base.:-
import Base.sprint

struct Clock
    time::Time
end

function Clock(hours::Int64, minutes::Int64)
    m = minutes
    minuteshours = div(abs(minutes), 60)
    h = hours
    if (minutes < 0)
        if (minuteshours > 0)
            m += minuteshours * 60
            h -= minuteshours
        end
        if (m < 0)
            m += 60
            h -= 1
        end
    else
        h += minuteshours
    end
    if (h < 0) h += (abs(div(h, 24)) + 1) * 24 end
    Clock(Time(h % 24, m % 60))
end

+(clock::Clock, minutes::Dates.Minute) = Clock(clock.time + minutes)
-(clock::Clock, minutes::Dates.Minute) = Clock(clock.time - minutes)
sprint(f::Function, clock::Clock) = sprint(f::Function, Dates.format(clock.time, "HH:MM"))

