fun response s =
  let
    val char_list = List.filter (fn c => not (Char.isSpace c)) (explode s)
    val empty = char_list = []
    val query = empty orelse (List.last char_list) = #"?"
    val shout = List.all (fn c => Char.isUpper c orelse not (Char.isAlpha c)) char_list
    val alpha = List.exists Char.isAlpha char_list
  in
    case (alpha, query, shout, empty) of
         (_, _, _, true)       => "Fine. Be that way!"
       | (true, true, true, _) => "Calm down, I know what I'm doing!"
       | (_, true, _, _)       => "Sure."
       | (true, _, true, _)    => "Whoa, chill out!"
       | _                     => "Whatever."
  end
