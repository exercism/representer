using Dates
function DaysInMonth(m, y)
    (m==4||m==6||m==9||m==11) && return 30
    m != 2 && return 31
    (y % 100 != 0 ? y % 400 == 0 : y % 4 == 0) && return 29
    return 28
end
function add_gigasecond(date::DateTime)
    time = 10^9 
    sec=(second(date)+time)%60
    min=((minute(date))+(second(date)+time)÷60)%60
    hr=((hour(date))+((minute(date))+(second(date)+time)÷60)÷60)%24
    dy=day(date)+((hour(date))+((minute(date))+(second(date)+time)÷60)÷60)÷24
    mth=month(date)
    yr=year(date)
    maxDay = DaysInMonth( mth, yr)
    while dy>maxDay
        dy -= maxDay
        mth += 1
        mth==13 && (mth = 1; yr += 1)
        maxDay = DaysInMonth( mth, yr)
    end
    return DateTime(yr, mth, dy, hr, min, sec) 
end