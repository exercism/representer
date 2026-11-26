import Base: show, +, -
import Dates.Minute
using Printf: @printf

function simplify_time(h::Int, m::Int)::Tuple{Int, Int}
  dur = 60 * h + m
  dur = mod(dur, 24 * 60)
  div(dur, 60), mod(dur, 60)
end


struct Clock
  h::Int
  m::Int
  Clock(h, m) = new(simplify_time(h, m)...)
end


#function show(io::IO, time::Clock)::Int
#  write(io, "\"$(lpad(time.h, 2, '0')):$(lpad(time.m, 2, '0'))\"")
#end

show(io::IO, time::Clock) = @printf(io, "\"%02d:%02d\"", time.h, time.m)


function +(c::Clock, m::Minute)::Clock
  Clock(c.h, c.m + m.value)
end


function -(c::Clock, m::Minute)::Clock
  Clock(c.h, c.m - m.value)
end

