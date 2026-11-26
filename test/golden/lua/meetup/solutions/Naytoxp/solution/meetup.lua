function IsTheRightDate(day, date)
    local dayName = os.date("%A", os.time({year=date.year, month=date.month, day=date.day}))
    return dayName == day and true or false
end
local weekType = {
    ["first"] = {start = 1, finish = 8, variation = 1}, ["second"] = {start = 8, finish = 14, variation = 1},
    ["third"] = {start = 15, finish = 23, variation = 1}, ["fourth"] = {start = 22, finish = 29, variation = 1},
    ["teenth"] = {start = 13, finish = 19, variation = 1}, ["last"] = {start = 31, finish = 1, variation = -1} -- Decrease because we want the last day of the month
}

local lastDay = { [1] = 31, [2] = 28, [3] = 31, [4] = 30, [5] = 31, [6] = 30, [7] = 31, [8] = 31, [9] = 30, [10] = 31, [11] = 32, [12] = 31 }

function LastDay(m, y)
    if y % 4 == 0 and y % 100 == 0  then
        if y % 400 == 0 then return 29
        else return 28
        end
    elseif y % 4 == 0 and y % 100 ~= 0 then return 29
    else return 28
    end
end

return function(date)
    if date.week == "last" then 
        if date.month == 2 then lastDay[2] = LastDay(2, date.year) end -- Updating last day for February to be sure if we are or not in a leap year or not
        weekType["last"].start = lastDay[date.month] 
    end 
    for k = weekType[date.week].start, weekType[date.week].finish, weekType[date.week].variation do
        if IsTheRightDate(date.day, { day = k, month = date.month, year = date.year }) then
            return k
        end
    end
end

