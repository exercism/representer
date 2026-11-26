module Grains exposing (square)

{-| Calculates the number of grains on the given square of a chessboard.

Each square has double the number of grains as the previous one:

  - Square 1 has 1 grain (2^0)
  - Square 2 has 2 grains (2^1)
  - Square 3 has 4 grains (2^2)
  - ...
  - Square 64 has 2^63 grains

If the input is not between 1 and 64, returns `Nothing`.

    square 1 --> Just 1

    square 3 --> Just 4

    square 64 --> Just 9223372036854775808

    square 0 --> Nothing

    square 100 --> Nothing

-}


square : Int -> Maybe Int
square n =
    if n < 1 || n > 64 then
        Nothing

    else
        Just (2 ^ (n - 1))
