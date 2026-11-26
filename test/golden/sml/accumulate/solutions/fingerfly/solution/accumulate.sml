fun accumulate (f, nil) = nil
 |  accumulate (f, (x::xs)) = f(x)::accumulate(f, xs)
  
