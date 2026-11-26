namespace TwoFer

def twoFer (name : Option String) : String :=
  let listener := name.getD "ypu"
  "One for " ++ listener ++ ", one for me."

end TwoFer
