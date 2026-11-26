datatype classification = Abundant | Deficient | Perfect

fun counter (from, to) = 
    if from >= to 
    then 
        nil 
    else 
        from :: counter(from + 1, to) 


fun divisible (a, b) = a mod b = 0


fun factors n =
    let val high_bound = 1.0 + Math.sqrt (real n) 
    
        val candidates = counter (1, floor high_bound)
        
        val factors = List.foldr (
            fn (k, acc) => if (n mod k) = 0
                        then 
                            let 
                                val q = n div k
                            in  
                                if q <> k then q::k::acc else k::acc
                            end
                        else 
                            acc
        ) [] candidates

    in factors 
    end


fun sum xs = List.foldr (op +) 0 xs

fun classify (input: int): classification option =
    if input < 1 
    then 
        NONE
    else
       let val acc = sum (tl (factors input)) 
       in 
           if acc = input 
           then 
              SOME Perfect
           else 
              if acc < input
              then 
                  SOME Deficient
              else 
                  SOME Abundant
       end
