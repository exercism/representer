module Series exposing (slices)


slices : Int -> String -> Result String (List (List Int))
slices size input =
  if size < 0
  then Err "slice length cannot be negative"
  else if  size == 0
  then Err "slice length cannot be zero"
  else if String.isEmpty input
  then Err "series cannot be empty"
  else if size > String.length input
  then Err "slice length cannot be greater than series length"
  else 
    input
    |> String.toList
    |> List.map (\char -> Char.toCode char - Char.toCode '0')
    |> tails
    |> List.take (String.length input - size + 1)
    |> List.map (List.take size)
    |> Ok

tails : List a -> List (List a)
tails list = case list of
  [] -> []
  x :: xs -> list :: tails xs