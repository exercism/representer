# define the Robot type
const NORTH = 0
const SOUTH = 2
const EAST = 3
const WEST = 1

moving_dirs = [(0, 1), (-1, 0), (0, -1), (1, 0)]

@kwdef struct Point
    x::Int64
    y::Int64
end

@kwdef mutable struct Robot
    x::Int64
    y::Int64
    dir::Int64
    Robot((x,y),d) = new(x,y, d)
end

position(r::Robot) = Point(r.x, r.y)
heading(r::Robot) = r.dir

function turn_right!(r::Robot) 
    r.dir -= 1
    r.dir = mod(r.dir, 4)
    return r
end

function turn_left!(r::Robot)
    r.dir += 1
    r.dir %= 4
    return r
end

function advance!(r::Robot)
    r.x += moving_dirs[r.dir+1][1]
    r.y += moving_dirs[r.dir+1][2]
    return r
end

function move!(r::Robot, s::String)
    for c in s
        if c == 'A'
            advance!(r)
        elseif c == 'R'
            turn_right!(r)
        elseif c == 'L'
            turn_left!(r)
        end
    end

    return r
end