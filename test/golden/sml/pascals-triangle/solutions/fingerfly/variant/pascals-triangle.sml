fun zipWith f nil _           = nil
  | zipWith f  _  nil         = nil
  | zipWith f (x::xs) (y::ys) = f (x, y) :: zipWith f xs ys 


fun mkLine nil  = nil 
  | mkLine list = let val xs = 1::list
                      val ys = list @ [0]
                  in zipWith (op +) xs ys
                  end 

fun rows 0     = nil
  | rows count = 
      let fun aux (0, acc) = aux (1, [[1]])
          |   aux (i, acc) = 
                if i >= count  
                then 
                  acc
                else
                  let val head::_ = acc
                  in aux (i + 1, mkLine head :: acc) 
                  end
          val pascals = aux(0, nil) 
      in rev pascals
      end