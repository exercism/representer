structure Wordy = struct
  fun splitString s =
    String.tokens (fn c => c = #" ") s

  fun strToIntOpt s =
    case Int.fromString s of
      SOME n => SOME n
    | NONE => 
        if String.size s > 0 andalso String.sub(s, 0) = #"~" 
        then Int.fromString(String.substring(s, 1, String.size s - 1))
        else NONE

  fun applyOp op1 a b =
    case op1 of
      "plus" => SOME(a + b)
    | "minus" => SOME(a - b)
    | "multiplied" => SOME(a * b)
    | "divided" => SOME(a div b)
    | _ => NONE

  fun processTokens tokens =
    case tokens of
      [] => NONE
    | [n] => strToIntOpt n
    | n::op1::"by"::n2::rest => 
        (case (strToIntOpt n, strToIntOpt n2) of
           (SOME num1, SOME num2) => 
             (case applyOp op1 num1 num2 of
                SOME result => processTokens (Int.toString result :: rest)
              | NONE => NONE)
         | _ => NONE)
    | n::op1::n2::rest =>
        (case (strToIntOpt n, strToIntOpt n2) of
           (SOME num1, SOME num2) => 
             (case applyOp op1 num1 num2 of
                SOME result => processTokens (Int.toString result :: rest)
              | NONE => NONE)
         | _ => NONE)
    | _ => NONE

  fun answer question =
    let
      val cleanQuestion = String.translate (fn c => if c = #"?" then " " else str c) question
      val tokens = splitString cleanQuestion
      
      fun isValidStart tokens =
        case tokens of
          "What"::"is"::rest => processTokens rest
        | _ => NONE
    in
      isValidStart tokens
    end
end

val answer = Wordy.answer