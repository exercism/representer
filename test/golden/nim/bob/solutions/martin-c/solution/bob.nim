## Exercism Nim track exercise 4: Bob
## Bob is a lackadaisical teenager. In conversation, his responses are very limited.
## Bob answers 'Sure.' if you ask him a question, such as "How are you?".
## He answers 'Whoa, chill out!' if you YELL AT HIM (in all capitals).
## He answers 'Calm down, I know what I'm doing!' if you yell a question at him.
## He says 'Fine. Be that way!' if you address him without actually saying anything.
## He answers 'Whatever.' to anything else.
## Bob's conversational partner is a purist when it comes to written communication and always follows 
## normal rules regarding sentence punctuation in English.


import strutils
import sequtils


type
  Statement = tuple
    empty: bool
    question: bool
    yelling: bool


func parse(input: string): Statement =
  ## parse an input string into a `Statement` type.
  let
    s = input.strip
    hasLower = s.any(isLowerAscii)
    hasUpper = s.any(isUpperAscii)
    hasDigit = s.any(isDigit)

  result.empty = not (hasLower or hasUpper or hasDigit)
  result.question = s.endsWith('?')
  result.yelling = hasUpper and not hasLower


func respond(s: Statement): string =
  ## Respond to a Statement s with a string of text.
  if s.question and not s.yelling:
    return "Sure."
  if s.yelling and not s.question:
    return "Whoa, chill out!"
  if s.yelling and s.question:
    return "Calm down, I know what I'm doing!"
  if s.empty:
    return "Fine. Be that way!"
  else:
    return "Whatever."


func hey*(input :string): string =
  input.parse.respond
