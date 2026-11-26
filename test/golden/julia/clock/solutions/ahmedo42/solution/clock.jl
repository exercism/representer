using Dates, Printf
import Base.+,Base.==,Base.-, Base.show
struct Clock
  hours :: Int
  minutes :: Int
  function Clock(hours,minutes)
      new(mod(hours + floor(minutes / 60), 24), mod(minutes,60))
  end
end

==(c1::Clock, c2::Clock) = c1.hours == c2.hours &&
                           c1.minutes == c2.minutes
+(c::Clock, m::Minute) = Clock(c.hours, c.minutes + m.value)
-(c::Clock, m::Minute) = Clock(c.hours, c.minutes - m.value)
function show(io::IO, c::Clock)
  print(io, @sprintf("\"%02d:%02d\"", c.hours, c.minutes))
end
