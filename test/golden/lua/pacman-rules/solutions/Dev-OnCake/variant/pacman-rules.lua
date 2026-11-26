local rules = {}

-- returns if Pac-Man was able to eat the ghost or not
function rules.eat_ghost(power_pellet_active, touching_ghost)
  -- eat_ghost body
    if power_pellet_active == true and touching_ghost == true then
      return true
    else
      return false
    end
    
end

-- returns if Pac-Man ate a power pellet or a dot
function rules.score(touching_power_pellet, touching_dot)
  -- score body
    if touching_power_pellet == true or touching_dot == true then
      return true
    else
      return false
    end
end

-- returns if Pac-Man lost by touching a ghost without a power pellet
function rules.lose(power_pellet_active, touching_ghost)
  -- lose body
    if power_pellet_active ~= false and touching_ghost == true then
      return true
    else
      return false
    end
end

-- returns if Pac-Man won by eating all dots and has not touched a ghost without a power pellet
function rules.win(has_eaten_all_dots, power_pellet_active, touching_ghost)
  -- win body
   return has_eaten_all_dots and not rules.lose(power_pellet_active, touching_ghost)
end

return rules
