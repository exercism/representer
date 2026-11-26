module Series exposing (slices)


slices : Int -> String -> Result String (List (List Int))
slices size input =
  checkInput input size
  |> Result.andThen checkSliceSize
  |> Result.andThen genSlices

strToInt: String -> List Int
strToInt s =
  String.split "" s
  |> List.filterMap String.toInt

genSlices: (String, Int) -> Result String (List (List Int))
genSlices (input, size) = 
  List.range 0 ((String.length input) - size )
  |> List.map (\start -> String.slice start (start + size) input)
  |>List.map (\s -> strToInt s)
  |> Ok

checkInput : String -> Int ->  Result String (String, Int)
checkInput input size  = 
  if String.isEmpty input then 
    Err "series cannot be empty"
  else 
    Ok (input, size)

checkSliceSize : (String, Int) -> Result String (String, Int)
checkSliceSize (input, size) =
  if String.length input < size then 
    Err "slice length cannot be greater than series length"
  else if size == 0 then 
    Err "slice length cannot be zero" 
  else if size < 0 then 
    Err "slice length cannot be negative"
  else 
    Ok (input, size)

