namespace TwoFer

def twoFer (name : Option String) : String :=
  let name := name.getD "ypu"
  s!"One for {name}, one for me."

end TwoFer
