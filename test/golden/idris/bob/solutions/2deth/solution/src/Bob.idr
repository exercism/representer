module Bob

import Data.List

export
response : String -> String
response x =
  let
    chars = filter (not . isSpace) (unpack x)
    -- question = isSuffixOf ['?'] chars
    question = Just '?' == last' chars
    yell =  any isUpper chars && all (not . isLower) chars
    silence = null chars
  in
    if question && yell then "Calm down, I know what I'm doing!"
    else if question then "Sure."
    else if yell then "Whoa, chill out!"
    else if silence then "Fine. Be that way!"
    else "Whatever."
