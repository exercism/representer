(* For lower case letters *)
fun invert c =
    let val az = Char.ord #"a" + Char.ord #"z"
    in Char.chr (az - Char.ord c) end

fun encodeList [] = []
  | encodeList (c::cs) =
    if Char.isAlpha c then (invert c) :: (encodeList cs)
    else if Char.isPunct c orelse Char.isSpace c then encodeList cs
    else c :: (encodeList cs);

fun addSpaces n cs =
    let
        fun aux 1 (c::cs) = #" " :: (aux n (c::cs))
          | aux i [] = []
          | aux i (c :: cs) = c :: (aux (i-1) cs)
    in
        aux n cs
    end;
	
fun encode (phrase: string): string =
    String.implode (addSpaces 5 (encodeList (List.map Char.toLower (String.explode phrase))))

fun decode (phrase: string): string =
    String.implode (encodeList (List.map Char.toLower (String.explode phrase)))