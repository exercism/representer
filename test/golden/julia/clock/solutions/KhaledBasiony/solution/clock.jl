using Dates
import Base.+
import Base.-
import Base.show

struct Clock
    hours::Int
    mins::Int
    Clock(x, y) = new(mod(floor(y/60) + x, 24), mod(y, 60))
end

+(a::Clock, b::Minute) = Clock(a.hours, a.mins + b.value)
+(b::Minute, a::Clock) = Clock(a.hours, a.mins + b.value)
-(a::Clock, b::Minute) = Clock(a.hours, a.mins - b.value)
-(b::Minute, a::Clock) = Clock(a.hours, a.mins - b.value)

show(io::IO, cl::Clock) = print(io, "\"$(string(cl.hours, pad=2)):$(string(cl.mins, pad=2))\"")
