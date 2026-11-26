namespace ReverseString

def reverse (value : String) : String :=
  value.foldl (fun acc c => c :: acc) [] |> String.mk

end ReverseString
