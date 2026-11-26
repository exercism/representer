fun isBalanced s =
    let
      fun matchClose bra xs =
          case xs of
              x :: xs => if x = bra
                        then SOME xs
                        else NONE
            | _ => NONE

      fun matchOpen bra xs =
          matchClose bra (eatPrefix xs)

      and eatPrefix xs =
          case goodPrefix xs of
              NONE => xs
            | SOME [] => []
            | SOME xs => eatPrefix xs

      and goodPrefix xs =
          case xs of
            (* Empty string is balanced *)
              [] => SOME []
            (* Match expressions starting with open bracket *)
            | #"(" :: xs => matchOpen #")" xs
            | #"[" :: xs => matchOpen #"]" xs
            | #"{" :: xs => matchOpen #"}" xs
            (* Stranded close brackets are not correct *)
            | #")" :: _ => NONE
            | #"]" :: _ => NONE
            | #"}" :: _ => NONE
            (* Skip all other characters *)
            | _ :: xs => SOME xs
    in
        null ( eatPrefix ( String.explode s ) )
    end
