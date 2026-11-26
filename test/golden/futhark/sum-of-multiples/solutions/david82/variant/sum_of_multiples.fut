-- Alternative histogram-based implementation
let sum_of_multiples (numbers: []i32) (upper_bound: i32): i32 = 
  if upper_bound <= 1 then 0
  else
    let valid_bases = numbers
                      |> filter (>0)
                      |> filter (<upper_bound)
    in if length valid_bases == 0 then 0
       else
         -- Create histogram to mark multiples directly
         let bound = i64.i32 upper_bound
         let histogram = replicate bound false
         let histogram' = loop acc = histogram for base in valid_bases do
           loop acc' = acc for k in 1..<(upper_bound / base + 1) do
             let multiple = base * k
             in if multiple <= upper_bound 
                then acc' with [i64.i32 multiple] = true
                else acc'
         -- Sum all indices that are marked as multiples (skip index 0)
         let indices = map i32.i64 (1..<bound)
         let multiples = map2 (\i is_mult -> if is_mult then i else 0) indices histogram'[1:]
         in reduce (+) 0 multiples
