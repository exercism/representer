local allergens = {
    [0] = "eggs", "peanuts", "shellfish", "strawberries", 
    "tomatoes", "chocolate", "pollen", "cats",        
    eggs = 0, peanuts = 1, shellfish = 2, strawberries = 3,
    tomatoes = 4, chocolate = 5, pollen = 6, cats = 7
}
    
local function list(score)
    local result = {}
    for i = 0, 7 do
        if score & 1 << i ~= 0 then
            table.insert(result, allergens[i])
        end
    end
    return result
end

local function allergic_to(score, which)
    return score & 1 << allergens[which] ~= 0
end

return {
  list = list,
  allergic_to = allergic_to
}
