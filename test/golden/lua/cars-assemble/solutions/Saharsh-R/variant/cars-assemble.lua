local cars = {}

-- returns the amount of working cars produced by the assembly line every hour
function cars.calculate_working_cars_per_hour(production_rate, success_rate)
  return production_rate * (success_rate ) / 100
  -- calculate_working_cars_per_hour body
end

-- returns the amount of working cars produced by the assembly line every minute
function cars.calculate_working_cars_per_minute(production_rate, success_rate)
  return cars.calculate_working_cars_per_hour(production_rate, success_rate) // 60
  -- calculate_working_cars_per_minute body
end

-- returns the cost of producing the given number of cars
function cars.calculate_cost(cars_count)
  local ones = cars_count % 10
  local tens = cars_count // 10
  local val = tens * 95 + ones / 10
  return val * 1000

  -- calculate_cost body
end

return cars
