module PhoneNumber exposing (getNumber)

import Char as C exposing (isDigit)
import List as L exposing (filter, length)
import Maybe as M exposing (andThen)
import String as S exposing (fromList, length, toList)


type FullPhoneNumber
    = WithoutCountryCode (List Char)
    | WithCountryCode (List Char)


type PhoneNumber
    = PhoneNumber (List Char)


clean : String -> List Char
clean s =
    L.filter C.isDigit <| S.toList s


toPhoneNumber : List Char -> Maybe FullPhoneNumber
toPhoneNumber cl =
    case L.length cl of
        10 ->
            WithoutCountryCode cl |> Just

        11 ->
            WithCountryCode cl |> Just

        _ ->
            Nothing


removeCountryCode : FullPhoneNumber -> Maybe PhoneNumber
removeCountryCode fpn =
    case fpn of
        WithCountryCode ('1' :: num) ->
            num |> PhoneNumber |> Just

        WithCountryCode _ ->
            Nothing

        WithoutCountryCode cl ->
            cl |> PhoneNumber |> Just


checkAreaCode : PhoneNumber -> Maybe PhoneNumber
checkAreaCode pn =
    case pn of
        PhoneNumber ('0' :: _) ->
            Nothing

        PhoneNumber ('1' :: _) ->
            Nothing

        PhoneNumber _ ->
            pn |> Just


checkExchangeCode : PhoneNumber -> Maybe PhoneNumber
checkExchangeCode pn =
    case pn of
        PhoneNumber (_ :: _ :: _ :: '0' :: _) ->
            Nothing

        PhoneNumber (_ :: _ :: _ :: '1' :: _) ->
            Nothing

        _ ->
            Just pn


fromPhoneNumber : PhoneNumber -> Maybe String
fromPhoneNumber pn =
    case pn of
        PhoneNumber cl ->
            cl |> S.fromList |> Just


getNumber : String -> Maybe String
getNumber s =
    clean s |> Just |> M.andThen toPhoneNumber |> M.andThen removeCountryCode |> M.andThen checkAreaCode |> M.andThen checkExchangeCode |> M.andThen fromPhoneNumber
