module Bob exposing (hey)


hey : String -> String
hey remark =
    let
        cleanRemark = String.trim remark
    in
    case (isAnAnswer cleanRemark, isYelling cleanRemark, isSayingNothing cleanRemark) of
        (_, _, True) ->
            "Fine. Be that way!"
        (True, False, _) ->
            "Sure."
        (False, True, _) ->
            "Whoa, chill out!"
        (True, True, _) ->
            "Calm down, I know what I'm doing!"
        _ ->
            "Whatever."
        

isAnAnswer : String -> Bool
isAnAnswer =
    String.endsWith "?"

isYelling : String -> Bool
isYelling remark =
    String.any Char.isAlpha remark
        |> (&&) (String.toUpper remark == remark)

isSayingNothing : String -> Bool
isSayingNothing =
    String.isEmpty
