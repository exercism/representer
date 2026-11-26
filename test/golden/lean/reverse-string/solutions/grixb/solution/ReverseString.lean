namespace ReverseString

def reverse (value : String) : String :=
  value.chars.fold (λ rev c => c::rev) []
  |> String.ofList

end ReverseString
