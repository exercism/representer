same = (l1, l2) ->
  for i, d in ipairs l1
    return false unless l2[i] == d
  true

sum = (dice) ->
  res = 0
  for d in *dice do res += d
  res

sum_xs = (dice, x) ->
  res = 0
  for d in *dice do res += d if d == x
  res

lookup =
  ones: (dice) -> sum_xs(dice, 1)
  twos: (dice) -> sum_xs(dice, 2)
  threes: (dice) -> sum_xs(dice, 3)
  fours: (dice) -> sum_xs(dice, 4)
  fives: (dice) -> sum_xs(dice, 5)
  sixes: (dice) -> sum_xs(dice, 6)
  'full house': (dice) ->
    table.sort dice
    if (dice[1] == dice[3] and dice[3] != dice[4] and dice[4] == dice[5]) or
      (dice[1] == dice[2] and dice[2] != dice[3] and dice[3] == dice[5])
      sum(dice)
    else 0
  'four of a kind': (dice) ->
    table.sort dice
    if dice[1] == dice[4] then sum([d for d in *dice[1, 4]])
    elseif dice[2] == dice[5] then sum([d for d in *dice[2, 5]])
    else 0
  'little straight': (dice) ->
    table.sort dice
    if same dice, {1, 2, 3, 4, 5} then 30 else 0
  'big straight': (dice) ->
    table.sort dice
    if same dice, {2, 3, 4, 5, 6} then 30 else 0
  yacht: (dice) -> 
    table.sort dice
    if dice[1] == dice[5] then 50 else 0
  choice: sum
  
{
  score: (category, dice) -> lookup[category](dice)
}
