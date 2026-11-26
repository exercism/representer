module AtbashCipher exposing (encode, decode)

import Char
import String
import List


-- Converte uma letra em sua letra "invertida" no alfabeto
atbashChar : Char -> Char
atbashChar c =
    if Char.isLower c then
        let
            offset = Char.toCode 'a'
            code = Char.toCode c
        in
        Char.fromCode (25 - (code - offset) + offset)
    else
        c


-- Remove tudo que não seja letra ou dígito, e converte para minúsculo
cleanInput : String -> String
cleanInput str =
    str
        |> String.toLower
        |> String.filter (\c -> Char.isLower c && Char.isDigit c)


-- Quebra string em grupos de n caracteres
groupN : Int -> String -> List String
groupN n str =
    if String.isEmpty str then
        []
    else
        let
            first = String.left n str
            rest = String.dropLeft n str
        in
        first :: groupN n rest


encode : String -> String
encode plain =
    plain
        |> cleanInput
        |> String.map atbashChar
        |> groupN 5
        |> String.join " "


decode : String -> String
decode cipher =
    cipher
        |> String.filter (\c -> Char.isLower c || Char.isDigit c)
        |> String.map atbashChar
