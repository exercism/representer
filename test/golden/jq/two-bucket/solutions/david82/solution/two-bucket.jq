def gcd(a; b):
  if b == 0 then a
  else gcd(b; a % b)
  end;

def solve_two_bucket:
  . as $input |
  
  # Extract input parameters
  .bucketOne as $c1 |
  .bucketTwo as $c2 |
  .goal as $goal |
  .startBucket as $start |
  
  # Check if goal is impossible
  if $goal > ($c1 | if . > $c2 then . else $c2 end) then
    "impossible" | halt_error(1)
  elif ($goal % gcd($c1; $c2)) != 0 then
    "impossible" | halt_error(1)
  else
    # Initialize state based on start bucket
    (if $start == "one" then [$c1, 0] else [0, $c2] end) as $initial_state |
    
    # BFS to find solution
    {
      queue: [[$initial_state, 1]],
      visited: {
        "0,0": true,
        (if $start == "one" then "0,\($c2)" else "\($c1),0" end): true
      }
    } |
    
    until(.queue == [] or .found;
      .queue[0] as $current |
      $current[0] as $state |
      $current[1] as $moves |
      $state[0] as $x1 |
      $state[1] as $x2 |
      
      if $x1 == $goal or $x2 == $goal then
        .found = {
          moves: $moves,
          goalBucket: (if $x1 == $goal then "one" else "two" end),
          otherBucket: (if $x1 == $goal then $x2 else $x1 end)
        }
      else
        .queue = .queue[1:] |
        
        # Generate all possible next states
        [
          # Empty bucket one
          [0, $x2],
          # Empty bucket two  
          [$x1, 0],
          # Pour from bucket one to bucket two
          ([$x1 - ([$x1, $c2 - $x2] | min), $x2 + ([$x1, $c2 - $x2] | min)]),
          # Pour from bucket two to bucket one
          ([$x1 + ([$x2, $c1 - $x1] | min), $x2 - ([$x2, $c1 - $x1] | min)]),
          # Fill bucket one
          [$c1, $x2],
          # Fill bucket two
          [$x1, $c2]
        ] as $next_states |
        
        reduce $next_states[] as $next_state (.;
          ($next_state | "\(.[0]),\(.[1])") as $state_key |
          if .visited[$state_key] | not then
            .visited[$state_key] = true |
            .queue += [[$next_state, $moves + 1]]
          else
            .
          end
        )
      end
    ) |
    
    if .found then
      .found
    else
      "impossible" | halt_error(1)
    end
  end;

solve_two_bucket
