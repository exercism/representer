fun isIsogram (phrase: string): bool =
    let
        (* Convert to lowercase and filter non-alphabetic characters *)
        fun processChars [] = []
          | processChars (c::cs) =
            if c = #"-" orelse c = #" " then
                processChars cs
            else
                Char.toLower c :: processChars cs

        (* Insert character into sorted list *)
        fun insert (x, []) = [x]
          | insert (x, y::ys) =
            if x <= y then x::y::ys
            else y::insert(x, ys)

        (* Sort list using insertion sort *)
        fun sort [] = []
          | sort (x::xs) = insert(x, sort xs)

        (* Check for adjacent duplicates in sorted list *)
        fun hasDuplicates [] = false
          | hasDuplicates [_] = true
          | hasDuplicates (x::y::rest) =
            x = y orelse hasDuplicates (y::rest)

        (* Process the input string *)
        val chars = String.explode phrase
        val processed = processChars chars
        val sorted = sort processed
    in
        not (hasDuplicates sorted)
    end