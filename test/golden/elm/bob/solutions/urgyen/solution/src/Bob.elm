module Bob exposing (hey)

isYelling x =
  List.any Char.isAlpha (String.toList x) && String.toUpper x == x

isQuestion =
  String.endsWith "?"

isSilence =
  String.isEmpty

hey : String -> String
hey =
  cases << String.trim

cases remark =
  if isYelling remark && isQuestion remark then
    "Calm down, I know what I'm doing!"
  else if isYelling remark then
    "Whoa, chill out!"
  else if isQuestion remark then
    "Sure."
  else if isSilence remark then
    "Fine. Be that way!"
  else
    "Whatever."
