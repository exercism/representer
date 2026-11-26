
using Dates

struct Clock
    hours::Int
    minutes::Int
end

function Base.:(==)(clock1::Clock, clock2::Clock)
    t1 = clock1.hours * 60 + clock1.minutes
    t2 = clock2.hours * 60 + clock2.minutes
    return (t1-t2)%1440 == 0
end

function Base.:+(clock::Clock, minutes::Minute)
    return Clock(clock.hours, clock.minutes + minutes.value)
end

function Base.:-(clock::Clock, minutes::Minute)
    return Clock(clock.hours, clock.minutes - minutes.value)
end

function Base.show(io::IO,clock::Clock)
    m = ((clock.hours*60+clock.minutes)%1440 + 1440)%1440
    h,m = divrem(m,60)
    print(io,"\"$(lpad(h,2,'0')):$(lpad(m,2,'0'))\"")
end