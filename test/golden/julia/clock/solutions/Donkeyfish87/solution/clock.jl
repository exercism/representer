using Dates
import Base: show, +,-

struct Clock
    hours::Int64
    minutes::Int64
   
    function Clock(hours, minutes)
        while minutes < 0
            minutes += 60
            hours -= 1
        end

        while hours < 0
            hours += 24
        end
        hours += div(minutes, 60)
        new(hours % 24, minutes % 60)
    end
end


function +(clock::Clock, minute::Minute)
    Clock(clock.hours, clock.minutes + minute.value)
end

function -(clock::Clock, minute::Minute)
    Clock(clock.hours, clock.minutes - minute.value)
end

function show(io::IO, clock::Clock)
    mins = clock.minutes < 10 ? string("0", clock.minutes) : string(clock.minutes)
    hrs = clock.hours < 10 ? string("0", clock.hours) : string(clock.hours)

    print(io, "\"$hrs:$mins\"")
end
