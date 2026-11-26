module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        n = String.filter Char.isDigit phoneNumber
        validate xs =
            case xs of
                (a::b::_::_::c::_) ->
                    a == "1" && b /= "0" && b /= "1" && c /= "0" && c /= "1"

                _ ->
                    False
    in
    case String.length n of
        11 ->
            if validate (String.split "" n) then
                Just <| String.dropLeft 1 n
            else
                Nothing

        10 ->
            if validate ("1"::String.split "" n) then
                Just n
            else
                Nothing

        _ ->
            Nothing
