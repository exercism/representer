module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        _ =
            Debug.log "{phoneNumber, phone)" ( phoneNumber, phone )

        phone =
            String.filter (\char -> Char.isDigit char) phoneNumber

        first =
            String.slice 0 1 phone

        rest =
            String.right 10 phone

        length =
            String.length phone

        isStrPresentAt start end str =
            String.slice start end phone == str

        isCodePresentAt pos str =
            isStrPresentAt pos (pos + 1) str

        isAreaOrExchCode pos =
            isCodePresentAt pos "0"
                || isCodePresentAt pos "1"
    in
    if isAreaOrExchCode 0 && length == 10 then
        Nothing

    else if isAreaOrExchCode 3 && length == 10 then
        Nothing

    else if first == "0" && length == 11 then
        Nothing

    else if isAreaOrExchCode 1 && length == 11 then
        Nothing

    else if first == "1" && isAreaOrExchCode 4 && length == 11 then
        Nothing

    else if String.length phone == 10 && first /= "0" then
        Just phone

    else if first == "1" && length == 11 then
        Just rest

    else if first == "1" && length == 12 then
        Just rest

    else
        Nothing



--
-- type Maybe abcd =
--   Just abcd
--   |Nothing
