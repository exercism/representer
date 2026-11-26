local ALLERGIES = {
	 "eggs",
	 "peanuts",
	 "shellfish",
	 "strawberries",
	 "tomatoes",
	 "chocolate",
	 "pollen",
	 "cats",
}

local function list(score)
  local allergies = {}
  for i, allergy in ipairs(ALLERGIES) do
    if score & (2 ^ (i - 1)) > 0 then
      table.insert(allergies, allergy)
    end
  end
  return allergies
end

local function allergic_to(score, which)
	for _, allergy in ipairs(list(score)) do
		if allergy == which then
			return true
		end
	end
	return false
end

return {
	list = list,
	allergic_to = allergic_to,
}
