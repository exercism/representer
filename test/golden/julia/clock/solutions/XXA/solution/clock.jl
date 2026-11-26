using Dates
using Printf
struct Clock
    hours::Int 
    minutes::Int 
    function Clock(h, m)
        h += div(m, 60)
        if m < 0
            if m % 60 != 0
                m = 60 + m % 60
                h -= 1
            else
                m = 0
            end
        else
            m = m % 60
        end

        if h < 0
            if h % 24 == 0 
                h = 0
            else
                h = 24 + h % 24
            end
        elseif h >= 24
            h = h % 24
        end
        new(h, m)
    end
end

function Base.show(io::IO, clk::Clock)
    @printf(io, "\"%02d:%02d\"", clk.hours, clk.minutes)
end

Base.:(+)(clk::Clock, min::Minute) = Clock(clk.hours, clk.minutes + min.value)
Base.:(-)(clk::Clock, min::Minute) = Clock(clk.hours, clk.minutes - min.value)
