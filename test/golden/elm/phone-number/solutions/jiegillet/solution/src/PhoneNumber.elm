module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber =
  let
    removeNonDigits =
      String.filter Char.isDigit

    removeLeadingOne number =
      if String.startsWith "1" number then 
        String.dropLeft 1 number
      else
        number

    hasNineDigits number = 
      if String.length number == 10 then 
        Just number
      else
        Nothing

    noLeadingZeroOrOne number = 
      if String.startsWith "0" number || String.startsWith "1"  number then 
        Nothing
      else
        Just number

    noLeadingZeroOrOneInExchangeCode number = 
      number
      |> String.dropLeft 3
      |> noLeadingZeroOrOne
      |> Maybe.map (always number)

  in
  removeNonDigits
  >> removeLeadingOne
  >> hasNineDigits
  >> Maybe.andThen noLeadingZeroOrOne
  >> Maybe.andThen noLeadingZeroOrOneInExchangeCode