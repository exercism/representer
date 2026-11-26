def knapsack(items; maximum_weight; n):
  if n == 0 or maximum_weight == 0 then
    0
  elif items[n - 1].weight > maximum_weight then
    knapsack(items; maximum_weight; n - 1)
  else
    knapsack(items; maximum_weight; n - 1) as $without_item
    | (items[n - 1].value + knapsack(items; maximum_weight - items[n - 1].weight; n - 1)) as $with_item
    | [$with_item, $without_item]
    | max
  end;

if (.items | length) == 0 then
  0
else
  knapsack(.items; .maximumWeight; (.items | length))
end