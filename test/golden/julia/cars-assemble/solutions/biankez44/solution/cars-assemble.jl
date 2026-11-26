function success_rate(speed)
    if speed == 0
        return 0.
    elseif speed ≥ 1 && speed ≤ 4
        return 1.
    elseif speed ≥ 5 && speed ≤ 8
        return .9
    elseif speed == 9
        return .8
    else
        return .77
    end
end

function production_rate_per_hour(speed)
    221*speed*success_rate(speed)
end

function working_items_per_minute(speed)
    floor(Int, production_rate_per_hour(speed) / 60)
end
