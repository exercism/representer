namespace Acronym

def abbreviate (phrase : String) : String :=
  phrase.splitToList (" -".contains ·)
  |> (·.filterMap $ (·.toList.filter (·.isAlpha) |> (·.head?.map .toUpper)))
  |> .ofList

end Acronym