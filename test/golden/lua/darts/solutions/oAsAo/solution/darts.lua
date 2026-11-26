local Darts = {}

local INNER  =  1 ^ 2
local MIDDLE =  5 ^ 2
local OUTER  = 10 ^ 2

function Darts.score(x, y)
    local sqr_distance = x*x + y*y
    return sqr_distance <= INNER and 10
            or sqr_distance <= MIDDLE and 5
            or sqr_distance <= OUTER and 1
            or 0
end

return Darts
