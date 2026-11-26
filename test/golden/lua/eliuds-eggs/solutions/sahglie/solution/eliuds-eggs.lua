local EliudsEggs = {}

function EliudsEggs.egg_count(number)
	local egg_count = 0
	while number > 0 do
		egg_count = egg_count + (number & 1)
		number = number >> 1
	end
	return egg_count
end

return EliudsEggs
