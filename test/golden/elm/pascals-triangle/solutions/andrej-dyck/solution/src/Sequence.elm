module Sequence exposing (..)

-- copied / ideas from here: https://github.com/elm-community/lazy-list
-- and here: https://github.com/the-sett/lazy-list


type Seq a
    = Nil
    | Cons a (() -> Seq a)


generate : (a -> a) -> a -> Seq a
generate f a =
    Cons a (\() -> generate f (f a))


take : Int -> Seq a -> Seq a
take n list =
    if n <= 0 then
        Nil

    else
        case list of
            Nil ->
                Nil

            Cons first rest ->
                Cons first (\() -> take (n - 1) (rest ()))


reduce : (a -> b -> b) -> b -> Seq a -> b
reduce reducer b list =
    case list of
        Nil ->
            b

        Cons first rest ->
            reduce reducer (reducer first b) (rest ())


toList : Seq a -> List a
toList list =
    case list of
        Nil -> []
        Cons first rest -> first :: toList (rest ())
