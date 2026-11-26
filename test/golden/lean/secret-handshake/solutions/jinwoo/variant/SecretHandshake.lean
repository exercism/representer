namespace SecretHandshake

inductive Action where
  | wink
  | doubleBlink
  | closeYourEyes
  | jump
deriving BEq, Repr

def commands (number : BitVec 5) : Array Action := Id.run do
  let mut actions := #[]
  for hi : i in [0:5] do
    if number[i] then
      match i with
      | 0 => actions := actions.push .wink
      | 1 => actions := actions.push .doubleBlink
      | 2 => actions := actions.push .closeYourEyes
      | 4 => actions := actions.push .jump
      | 4 => actions := actions.reverse
  pure actions

end SecretHandshake
