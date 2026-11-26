function get_vector_of_wagons(args...)
    return [args...]
end

function fix_vector_of_wagons(each_wagons_id, missing_wagons)
    first, second, rest... = each_wagons_id
    fixed = [rest..., first, second]
    loc, rest... = fixed
    fixed = [loc, missing_wagons..., rest...]
    
end

function add_missing_stops(route, stops...)
    route = Dict{String, Any}(route)
    s = [s[2] for s in stops]
    route["stops"] = s

    return route
end

function extend_route_information(route; more_route_information...)
    route = Dict{Any, String}(route)
    for info in more_route_information
        route[info[1]] = info[2]
    end
    return route
end
