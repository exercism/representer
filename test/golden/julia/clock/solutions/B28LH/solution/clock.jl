using Dates

struct Clock
    h :: Int
    m :: Int
    function Clock(h, m)
        totalMins = 60*h + m
        # To deal with negative totalMins, use 1440 minutes in a day
        if totalMins < 0 totalMins = 1440 + (totalMins % 1440) end
        (newH, newM) = divrem(totalMins, 60)
        new(newH % 24, newM)
    end
end

Base.:(==)(c1::Clock, c2::Clock) = c1.h == c2.h && c1.m == c2.m
Base.:+(c::Clock, t::Minute) = Clock(c.h, c.m + t.value)
Base.:-(c::Clock, t::Minute) = Clock(c.h, c.m - t.value)

zpad(x) = lpad(string(x), 2, "0")
Base.show(io::IO, c::Clock) = print(io, "\"$(zpad(c.h)):$(zpad(c.m))\"")