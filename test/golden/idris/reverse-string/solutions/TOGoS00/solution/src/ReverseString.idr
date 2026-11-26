module ReverseString

-- floored half; let's do it without cast/div or whatever, for funzies:
flalf : Nat -> Nat
flalf Z = Z
flalf (S Z) = Z
flalf (S (S n)) = (S (flalf n))

export
rev : String -> String
rev str =
    if endIdx < 2 then str
    else (rev (substr midIdx endIdx str)) ++ (rev (substr 0 midIdx str))
    where
        endIdx : Nat
        endIdx = length str
        midIdx : Nat
        midIdx = flalf endIdx
