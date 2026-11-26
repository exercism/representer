module BeerSong

let rec recite (startBottles: int) (takeDown: int) =
    let first =
        match startBottles with
        | 0 -> "No more bottles of beer on the wall, no more bottles of beer."
        | 1 -> "1 bottle of beer on the wall, 1 bottle of beer."
        | n -> $"{n} bottles of beer on the wall, {n} bottles of beer."

    let second =
        match startBottles with
        | 0 -> "Go to the store and buy some more, 99 bottles of beer on the wall."
        | 1 -> "Take it down and pass it around, no more bottles of beer on the wall."
        | 2 -> "Take one down and pass it around, 1 bottle of beer on the wall."
        | n -> $"Take one down and pass it around, {n - 1} bottles of beer on the wall."

    let next =
        match takeDown with
        | 1 -> []
        | n -> ("" :: (recite (startBottles - 1) (n - 1)))

    first :: second :: next