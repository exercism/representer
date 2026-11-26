module TwelveDays

let dayth = Map [
  (1, "first")
  (2, "second")
  (3, "third")
  (4, "fourth")
  (5, "fifth")
  (6, "sixth")
  (7, "seventh")
  (8, "eighth")
  (9, "ninth")
  (10, "tenth")
  (11, "eleventh")
  (12, "twelfth")
]

let gifts = Map [
  (1, "a Partridge in a Pear Tree")
  (2, "two Turtle Doves")
  (3, "three French Hens")
  (4, "four Calling Birds")
  (5, "five Gold Rings")
  (6, "six Geese-a-Laying")
  (7, "seven Swans-a-Swimming")
  (8, "eight Maids-a-Milking")
  (9, "nine Ladies Dancing")
  (10, "ten Lords-a-Leaping")
  (11, "eleven Pipers Piping")
  (12, "twelve Drummers Drumming")
]

let generateLine lineNumber =
  if lineNumber = 1 then
    "On the first day of Christmas my true love gave to me: a Partridge in a Pear Tree."
  else
    let line = "On the " + dayth[lineNumber] + " day of Christmas my true love gave to me: "
    let rec loop line loopNum =
      match loopNum with
      | loopNum when loopNum = lineNumber ->
        loop (line + gifts[loopNum]) (loopNum - 1)
      | 1 ->
        line + ", and " + gifts[loopNum] + "."
      | _ -> loop (line + ", " + gifts[loopNum]) (loopNum - 1)
    loop line lineNumber

let recite start stop =
  [start..stop] |> List.fold(
    fun (lines: string list) lineNumber ->
      generateLine lineNumber :: lines
  ) [] |> List.rev