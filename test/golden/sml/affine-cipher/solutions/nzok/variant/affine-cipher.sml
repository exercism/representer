local

   fun coprime x y =
       if x <= 0 orelse y <= 0 then false else
       let fun loop b s = if s = 1 then b else loop s (b mod s)
	in (if x > y then loop x y else
	    if x < y then loop y x else x) = 1
       end

   fun mod_inverse a m =
       let fun loop x y = if y = 1 then x else loop y ((y * a) mod m)
	in loop 1 a
       end

   fun transcode g f s =
       let fun recode c = if Char.isDigit c then c else
			  chr (ord #"a" + f (ord (Char.toLower c) - ord #"a"))
	in (implode o g o map recode o List.filter Char.isAlphaNum o explode) s
       end

in
   fun encode ({a, b}, s) =
       if not (coprime a 26) then raise Fail "a and m must be coprime." else
       let fun fives (a::b::c::d::e::f::xs) =
		      a::b::c::d::e:: #" " ::fives (f::xs)
	     | fives xs = xs
	in transcode fives (fn n => (a * n + b) mod 26) s
       end

   fun decode ({a, b}, s) =
       if not (coprime a 26) then raise Fail "a and m must be coprime." else
       let val a' = mod_inverse a 26
	in transcode (fn x => x) (fn n => ((n - b) * a') mod 26) s
       end

end
