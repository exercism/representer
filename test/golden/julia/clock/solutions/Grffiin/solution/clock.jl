import Base.==, Base.+, Base.-

mutable struct Clock
    hours::Int
    mins::Int

    function Clock(hours, mins)
        # Handle mins greater than 59
        if mins > 59
           extraHours = fld(mins, 60)
           remMins = mins - (60*extraHours)

        # Handle mins less than 0
        elseif mins < 0
            extraHours = fld(mins, 60)
            remMins = abs((60 * -(extraHours)) + mins)

        # Handle mins 0 <= x <= 59
        else
            extraHours = 0
            remMins = mins
        end
        afterHours = mod(hours + extraHours, 24)

        new(afterHours, remMins)
    end

end

function ==(x::Clock, y::Clock)
    if x.hours == y.hours && x.mins == y.mins
        return true
    end
    return false
end

function +(x::Clock, y::Minute)
    return Clock(x.hours, x.mins + y.value)
end

function -(x::Clock, y::Minute)
    return Clock(x.hours, x.mins - y.value)
end

function show(io::IO, x::Clock)
    print(io, "\"", lpad(x.hours, 2, "0"), ":", lpad(x.mins, 2, "0"), "\"")
end
