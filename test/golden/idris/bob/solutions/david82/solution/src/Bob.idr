module Bob

import Data.String
import Data.List

-- Helper function to check if a character is a letter
isLetter : Char -> Bool
isLetter c = (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')

-- Helper function to check if a character is uppercase
isUpper : Char -> Bool
isUpper c = c >= 'A' && c <= 'Z'

-- Helper function to check if a string contains any letters
hasLetters : String -> Bool
hasLetters str = any isLetter (unpack str)

-- Helper function to check if all letters in a string are uppercase
isYelling : String -> Bool
isYelling str = 
  let chars = unpack str
      letters = filter isLetter chars
  in case letters of
       [] => False  -- No letters means not yelling
       _  => all Bob.isUpper letters

-- Helper function to check if string is a question
isQuestion : String -> Bool
isQuestion str = 
  let trimmed = trim str
      chars = unpack trimmed
  in case chars of
       [] => False
       _  => case reverse chars of
               [] => False  -- This shouldn't happen but needed for totality
               (c :: _) => c == '?'

-- Helper function to check if string is empty or only whitespace
isEmpty : String -> Bool
isEmpty str = trim str == ""

export
response : String -> String
response input = 
  if isEmpty input 
    then "Fine. Be that way!"
  else if isYelling input && isQuestion input 
    then "Calm down, I know what I'm doing!"
  else if isYelling input 
    then "Whoa, chill out!"
  else if isQuestion input 
    then "Sure."
  else "Whatever."
  