module SimpleCipher exposing (decode, encode, keyGen)

import Random exposing (Generator)


toIntList : String -> List Int
toIntList s =
    String.toList s
        |> List.map (\x -> Char.toCode x - Char.toCode 'a')


toString : List Int -> String
toString list =
    List.map (\x -> x + Char.toCode 'a') list
        |> List.map Char.fromCode
        |> String.fromList


cycle : Int -> String -> List Int
cycle length key =
    let
        keyLen = String.length key
        multiple = (length + keyLen + 1) // keyLen
    in
        String.repeat multiple key
            |> toIntList


encode : String -> String -> String
encode key plaintext =
    List.map2 (\x y -> modBy 26 (x + y)) (toIntList plaintext) (cycle (String.length plaintext) key)
        |> toString


decode : String -> String -> String
decode key ciphertext =
    List.map2 (\x y -> modBy 26 (x - y)) (toIntList ciphertext) (cycle (String.length ciphertext) key)
        |> toString


keyGen : Generator String
keyGen =
    Random.list 100 (Random.int 0 25)
        |> Random.map toString
