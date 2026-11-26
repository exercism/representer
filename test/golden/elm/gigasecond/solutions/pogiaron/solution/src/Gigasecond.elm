module Gigasecond exposing (add)

import Time

gigamilisecond = 10^9 * 10^3

add : Time.Posix -> Time.Posix
add timestamp =
    timestamp 
    |> Time.posixToMillis 
    |> (+) gigamilisecond 
    |> Time.millisToPosix
