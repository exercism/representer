function label(colors)
    color_map = Dict(
        "black" => 0,
        "brown" => 1,
        "red" => 2,
        "orange" => 3,
        "yellow" => 4,
        "green" => 5,
        "blue" => 6,
        "violet" => 7,
        "grey" => 8,
        "white" => 9
    )

    first = color_map[colors[1]]
    second = color_map[colors[2]]
    multiplier = color_map[colors[3]]

    value = (first * 10 + second) * 10.0^multiplier

    function format_value(val, unit)
        isinteger(val) ? string(Int(val), " ", unit) : string(val, " ", unit)
    end

    if value >= 1_000_000_000
        return format_value(value / 1_000_000_000, "gigaohms")
    elseif value >= 1_000_000
        return format_value(value / 1_000_000, "megaohms")
    elseif value >= 1_000
        return format_value(value / 1_000, "kiloohms")
    else
        return string(Int(value), " ohms")
    end
end
