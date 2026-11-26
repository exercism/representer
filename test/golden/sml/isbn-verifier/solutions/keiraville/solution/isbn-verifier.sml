val isValid: string -> bool =
  let
    fun digitValue (c: char): int =
      Char.ord c - Char.ord #"0"
    fun recurse (weight: int) (total: int) (l: char list): bool =
      case (weight, l) of
          (_, #"-" :: rest) => recurse weight total rest
        | (0, nil) => total mod 11 = 0
        | (_, nil) => false
        | (1, #"X" :: nil) => total mod 11 = 1
        | (_, c :: rest) => Char.isDigit c andalso recurse (weight - 1) (total + weight * (digitValue c)) rest
  in
    recurse 10 0 o String.explode
  end
