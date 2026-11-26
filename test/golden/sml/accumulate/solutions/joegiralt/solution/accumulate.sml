fun accumulate (f, xs) =
  let 
    fun inner_map (acc, func, rest: 'a list) =
        case rest of
            []      => acc
          | y::ys => inner_map (acc @ [func y], func, ys) 
  in
    inner_map ([], f, xs)
  end   
                
