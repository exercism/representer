module PascalsTriangle exposing (rows)


import Sequence as Seq


rows : Int -> List (List Int)
rows n =
    Seq.generate nextRow [1]
    |> Seq.take n
    |> Seq.toList


nextRow r =
    List.map2 (+) (0 :: r) (r ++ [0])
