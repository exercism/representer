fun trim s =
  implode (List.filter (fn x => Char.isSpace x = false) (explode s));

fun question s =
  if str (String.sub (trim(s),(size (trim s)-1 )))="?"
   then true
  else false;

fun allCaps s = 
  if length (List.filter (fn x => Char.isUpper x) (explode s)) = length (List.filter (fn x => Char.isAlpha x) (explode s)) andalso (length (List.filter (fn x => Char.isUpper x) (explode s)) > 0)
  then true
  else false;

fun isEmpty s =
  if length (List.filter (fn x => Char.isSpace x = false) (explode s))=0
  then true
  else false;

fun response s =
   if isEmpty s
    then "Fine. Be that way!"
   else if question s andalso allCaps s
    then "Calm down, I know what I'm doing!"
   else if question s
    then "Sure."
   else if allCaps s
    then "Whoa, chill out!"
   else "Whatever.";
