-- Simple bubble sort for small arrays
def bubble_sort (arr: [6]i32): [6]i32 =
  loop sorted = copy arr for pass < 6 do
    loop temp = sorted for i < 5 do
      if temp[i] > temp[i+1]
      then (temp with [i] = temp[i+1]) with [i+1] = temp[i]
      else temp

def total (basket: []i32): i32 =
  let book_count = 5
  let book_price = 800
  let group_size_factor = [0.0, 1.0, 0.95, 0.90, 0.80, 0.75]
  
  -- Create tally array for books 0-5
  let tally = replicate 6 0
  let tally = loop tally for book in basket do
    if book >= 0 && book <= 5
    then tally with [book] = tally[book] + 1
    else tally
  
  -- Sort the tally array
  let sorted_tally = bubble_sort tally
  
  -- Calculate groups based on differences
  let groups = replicate 6 0
  let groups = loop groups for i in 1..<6 do
    let diff = sorted_tally[book_count - i + 1] - sorted_tally[book_count - i]
    in groups with [i] = diff
  
  -- Apply the key optimization: convert groups of 3 and 5 to groups of 4
  let (final_groups3, final_groups5, final_groups4) = 
    loop (g3, g5, g4) = (groups[3], groups[5], groups[4]) 
    while g3 > 0 && g5 > 0 do
      (g3 - 1, g5 - 1, g4 + 2)
  
  let final_groups = ((groups with [3] = final_groups3) 
                             with [5] = final_groups5) 
                             with [4] = final_groups4
  
  -- Calculate total cost
  let total_cost = loop cost = 0.0 for size in 1..<6 do
    let group_cost = f32.i32 book_price * f32.i32 (final_groups[size] * size) * group_size_factor[size]
    in cost + group_cost
  
  in i32.f32 total_cost
        