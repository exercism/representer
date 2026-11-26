module RnaTranscription exposing (toRNA)


dnaToRnaComplement : Char -> Result String Char
dnaToRnaComplement c =
    case c of
        'G' ->
            Ok 'C'

        'C' ->
            Ok 'G'

        'T' ->
            Ok 'A'

        'A' ->
            Ok 'U'

        _ ->
            Err (String.fromChar c)


toRNA : String -> Result String String
toRNA dna =
    String.foldr
        (\c resultAcc ->
            resultAcc
                |> Result.andThen
                    (\acc ->
                        dnaToRnaComplement c
                            |> Result.filter (\comp -> String.cons comp acc)
                    )
        )
        (Ok "")
        dna
