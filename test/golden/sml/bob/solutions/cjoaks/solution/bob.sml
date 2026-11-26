fun strip s = String.translate 
    (fn c => if Char.isDigit c orelse Char.isAlpha c then Char.toString c else "") s

fun isQuestion s = 
    let 
        fun endingOf [] c = [c]
          | endingOf (#" "::xs) c = endingOf xs c
          | endingOf (x::xs) c = endingOf xs x  
    in 
        endingOf (explode s) #" " = [#"?"]
    end 

fun response s = 
    let 
        val isQ = isQuestion s
        val isCap = foldl (fn (c,acc) => (Char.isDigit c orelse Char.isUpper c) andalso acc) true 
                    (explode (strip s))
                    andalso foldl (fn (c,acc) => Char.isAlpha c orelse acc) false (explode (strip s)) 
    in 
        if (strip s) = "" andalso not isQ then "Fine. Be that way!"
        else if isCap andalso isQ then "Calm down, I know what I'm doing!"
        else if isCap then "Whoa, chill out!"
        else if isQ then "Sure."
        else "Whatever."
    end
        
