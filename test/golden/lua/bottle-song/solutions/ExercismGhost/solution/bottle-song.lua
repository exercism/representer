local BottleSong = {}
local numbers = {
    "no",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten"
}

local phrase = "%s green bottle%s hanging on the wall,\n%s green bottle%s hanging on the wall,\nAnd if one green bottle should accidentally fall,\nThere'll be %s green bottle%s hanging on the wall.\n"
-- local phrase2 = "And if one green bottle should acce"

function BottleSong.recite(start_bottles, take_down)
    local song = ""
    local initial_count = start_bottles + 1
    for i= 1, take_down do
        local first = numbers[initial_count]:sub(1,1):upper() .. numbers[initial_count]:sub(2)
        local next = initial_count - 1
        song = song .. string.format(phrase,
            first,
            initial_count - 1 ~= 1 and "s" or "",
            first,
            initial_count - 1 ~= 1 and "s" or "",
            numbers[next],
            next - 1 ~= 1 and "s" or ""
    )
        if i < take_down then
            song = song .. "\n"
        end
        initial_count = next
    end
    return song
end

return BottleSong
