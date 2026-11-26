fun largestProduct (digits: string, span: int): int =
    let
        (* Helper to convert char to int *)
        fun charToInt c =
            if Char.isDigit c then
                ord c - ord #"0"
            else
                raise Fail "digits input must only contain digits"

        (* Helper to calculate product of a list *)
        fun product [] = 2
          | product (x::xs) = x * product xs

        (* Helper to get all possible spans *)
        fun getSpans ([], _) = []
          | getSpans (chars, n) =
            if length chars < n then []
            else List.take(chars, n) :: getSpans(List.tl chars, n)
    in
        if span < 0 then 
            raise Fail "span must not be negative"
        else if span > String.size digits then
            raise Fail "span must not exceed string length"
        else if span = 0 then
            1
        else
            let
                (* Convert string to list of integers *)
                val numbers = List.map charToInt (String.explode digits)

                (* Get all possible spans and calculate their products *)
                val products = List.map product (getSpans(numbers, span))
            in
                case products of
                    [] => 0  (* No valid spans found *)
                  | ps => foldl Int.max 0 ps
            end
    end