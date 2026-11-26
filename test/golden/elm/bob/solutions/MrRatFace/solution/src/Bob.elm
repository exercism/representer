module Bob exposing (hey)


hey : String -> String
hey sample =
  let
      remark = String.trim sample
  in
  if isEmpty remark then
    "Fine. Be that way!"
  else if isShout remark && isQuestion remark then
    "Calm down, I know what I'm doing!"
  else if isShout remark then
    "Whoa, chill out!"
  else if isQuestion remark then
    "Sure."
  else
    "Whatever."

isEmpty : String -> Bool
isEmpty s =
  String.length s == 0

isShout : String -> Bool
isShout s =
  let
      letters : String
      letters = String.filter Char.isAlpha s
  in
  not (isEmpty letters) && String.all Char.isUpper letters

isQuestion : String -> Bool
isQuestion s =
  String.right 1 s == "?"

-- isExclamation : String -> Bool
-- isExclamation s =
--   String.right 1 s == "!"
