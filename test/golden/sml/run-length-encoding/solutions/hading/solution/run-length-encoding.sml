fun decode' s acc =
    case Substring.first s of
        NONE => String.concat (rev acc)
      | SOME c => if Char.isDigit c then
                      let
                          val (numStr, tail) = Substring.splitl Char.isDigit s
                          val num = (valOf o Int.fromString o Substring.string) numStr
                          val rest = Substring.slice(tail, 1, NONE)
                          val char = Substring.first tail
                      in
                          case char of
                              NONE => raise Fail "No letter to use"
                            | SOME c => let
                                val charStr = String.implode (List.tabulate(num, fn _ => c))
                            in
                                decode' rest (charStr::acc)
                            end
                      end
                  else
                      decode' (Substring.slice(s, 1, NONE)) ((Char.toString c)::acc)


fun decode (phrase: string): string =
    decode' (Substring.full phrase) []

fun encode' s acc =
    case Substring.first s of
        NONE => String.concat (rev acc)
      | SOME c =>
        let
            val (cs, rest) = Substring.splitl (fn x => x = c) s
            val l = Substring.size cs
            val lStr = Int.toString l
            val cStr = Char.toString c
            val str = if l = 1 then cStr else lStr ^ cStr
        in
            encode' rest (str::acc)
        end

fun encode (phrase: string): string =
    encode' (Substring.full phrase) []
