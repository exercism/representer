using Dates, Base

struct Clock
    h
    m

    function Clock(h,m)
        newMinutes = m % 60
        newHour = (h + trunc(Int, m/60)) % 24

        if newMinutes < 0
            newMinutes += 60
            newHour -= 1
        end
        if newHour < 0
            newHour += 24
        end

        new(newHour,newMinutes)
    end
end

Base.:-(c::Clock,d::Minute) = Clock(c.h, c.m - d.value)
Base.:+(c::Clock,d::Minute) = Clock(c.h, c.m + d.value)
Base.show(io::IO, c::Clock) = print(io, "\"$(lpad(c.h,2,"0")):$(lpad(c.m,2,"0"))\"")