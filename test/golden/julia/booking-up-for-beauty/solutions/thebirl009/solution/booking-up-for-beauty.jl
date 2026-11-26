function schedule_appointment(str::String)
    return DateTime(str, "mm/dd/yyyy HH:MM:SS")
end

function has_passed(dt::DateTime)
    return dt < now()
end

function is_afternoon_appointment(dt::DateTime)
    return 12 <= hour(dt) < 18
end

function describe(dt::DateTime)
    return "You have an appointment on $(Dates.dayname(dt)), " *
           "$(Dates.monthname(dt)) $(day(dt)), " *
           "$(year(dt)) at $(Dates.format(dt, "HH:MM"))"
end

function anniversary_date()
    return Date(year(now()), 9, 15)
end