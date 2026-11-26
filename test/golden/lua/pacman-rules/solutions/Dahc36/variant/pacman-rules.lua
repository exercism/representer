local rules = {}

-- returns if Pac-Man was able to eat the ghost or not
function rules.eat_ghost(power_pellet_active, touching_ghost)
	-- eat_ghost body
	if not power_pellet_active then
		return false
	end
	if not touching_ghost then
		return false
	end
	return true
end

-- returns if Pac-Man ate a power pellet or a dot
function rules.score(touching_power_pellet, touching_dot)
	-- score body
	if touching_dot then
		return true
	end
	if touching_power_pellet then
		return true
	end
	return false
end

-- returns if Pac-Man lost by touching a ghost without a power pellet
function rules.lose(power_pellet_active, touching_ghost)
	-- lose body
	if not touching_ghost then
		return false
	end
	if power_pellet_active then
		return false
	end
	return true
end

-- returns if Pac-Man won by eating all dots and has not touched a ghost without a power pellet
function rules.win(has_eaten_all_dots, power_pellet_active, touching_ghost)
	-- win body
	if rules.lose(power_pellet_active, touching_ghost) then
		return false
	end
	if has_eaten_all_dots then
		return false
	end
	return false
end

return rules
