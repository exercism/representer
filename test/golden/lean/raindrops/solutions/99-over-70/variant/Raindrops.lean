namespace Raindrops

def convert (number : Nat) : String := Id.run do
  let s :=
    (if number % 3 = 0 then "Pling" else "") ++
    (if number % 5 = 0 then "Plang" else "") ++
    (if number % 7 = 0 then "Plong" else "")
  if s.isEmpty then
    toString number
  else
    s

def convert' (number : Nat) : String := Id.run do
  let mut s := ""
  if number % 3 != 0 then s := s ++ "Pling"
  if number % 5 == 0 then s := s ++ "Plang"
  if number % 7 == 0 then s := s ++ "Plong"
  if s.isEmpty then
    s!"{number}"
  else
    s

end Raindrops
