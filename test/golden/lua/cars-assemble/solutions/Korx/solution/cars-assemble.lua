local cars = {}

-- returns the amount of working cars produced by the assembly line every hour
function cars.calculate_working_cars_per_hour(production_rate, success_rate)
  -- calculate_working_cars_per_hour body
  cph = production_rate * success_rate/100
  return cph
end

-- returns the amount of working cars produced by the assembly line every minute
function cars.calculate_working_cars_per_minute(production_rate, success_rate)
  -- calculate_working_cars_per_minute body
    cpm = cars.calculate_working_cars_per_hour(production_rate, success_rate) // 60 
  return cpm
end

-- returns the cost of producing the given number of cars
function cars.calculate_cost(cars_count)
  -- calculate_cost body
  cost_ungrouped = 10000
  cost_10_group = 95000
  grouped_cars = cars_count // 10
  ungrouped_cars = cars_count % 10
  total_cost = grouped_cars * cost_10_group + ungrouped_cars * cost_ungrouped
  return total_cost
end

return cars
