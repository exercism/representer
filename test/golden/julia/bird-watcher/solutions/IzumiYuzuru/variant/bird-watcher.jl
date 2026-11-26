function today(birds_per_day)
    birds_per_day[end]
end

function increment_todays_count(birds_per_day)
    birds_per_day[end] += 1
    birds_per_day
end

function has_day_without_birds(birds_per_day)
    0 in birds_per_day
end

function count_for_first_days(birds_per_day, num_days)
    reduce(+, birds_per_day[1:num_days])
end

function busy_days(birds_per_day) 
    sum_busydays = 0
    for i in birds_per_day
        if i > 5
            sum_busydays += 1
        end
    end
    sum_busydays
end

function average_per_day(week1, week2)
    birds_average = []
    for i in 1:7
        push!(birds_average, (week1[i] + week2[i])/2)
    end
    birds_average
end
