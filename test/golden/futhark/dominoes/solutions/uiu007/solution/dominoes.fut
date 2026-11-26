def compute_degrees [n] (dominoes: [n][2]i32) (num_nodes: i64): []i32 =
  let indices = map (\i -> i64.i32 dominoes[i / 2, i % 2]) (iota (2 * n))
  let vals = replicate (2 * n) 1
  in reduce_by_index (replicate num_nodes 0) (+) 0 indices vals

def check_even_degrees (degrees: []i32): bool =
  map (\d -> d % 2 == 0) degrees 
  |> reduce (&&) true

def union_find [n] (dominoes: [n][2]i32) (num_nodes: i64): []i64 =
  let P_init = iota num_nodes
  let (P_final, _) =
    loop (P, changed) = (P_init, true) while changed do
      let P_jump = map (\p -> P[p]) P
      
      let (hook_idx, hook_val) =
        map (\d ->
          let u = P_jump[i64.i32 d[0]]
          let v = P_jump[i64.i32 d[1]]
          in if u < v then (v, u)
             else if v < u then (u, v)
             else (-1, -1)
        ) dominoes
        |> unzip
        
      let P_hooked = 
        reduce_by_index (copy P_jump) i64.min i64.highest hook_idx hook_val
        
      let changed_now = 
        map2 (!=) P P_hooked 
        |> reduce (||) false
        
      in (P_hooked, changed_now)
  in P_final

def check_connectivity (degrees: []i32) (parents: []i64): bool =
  let active_nodes = filter (\i -> degrees[i] > 0) (iota (length degrees))
  
  in if length active_nodes == 0 then true
     else
       let first_root = parents[active_nodes[0]]
       in map (\i -> parents[i] == first_root) active_nodes 
          |> reduce (&&) true

def can_chain [n] (dominoes: [n][2]i32): bool =
  if n == 0 then true
  else
    let max_node = 
      map (\d -> i32.max d[0] d[1]) dominoes 
      |> reduce i32.max 0
    let num_nodes = i64.i32 (max_node + 1)
    
    let degrees = compute_degrees dominoes num_nodes
    let is_even = check_even_degrees degrees
    
    let parents = union_find dominoes num_nodes
    let is_connected = check_connectivity degrees parents
    
    in is_even && is_connected