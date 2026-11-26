namespace AtbashCipher

private def atbashChar (c : Char) : Option Char :=
  let c := c.toLower
  if c.isAlpha then some (Char.ofNat ('z'.toNat + 'a'.toNat - c.toNat))
  else if c.isDigit then some c
  else none

def encodeOriginal (phrase : String) : String :=
  let ciphered := phrase.toList.filterMap atbashChar
  let n := ciphered.length
  let groups := List.range ((n + 4) / 5) |>.map fun i =>
    String.ofList (ciphered.drop (i * 5) |>.take 5)
  String.intercalate " " groups

def decodeOriginal (phrase : String) : String :=
  String.ofList (phrase.toList.filterMap atbashChar)

def encode (phrase : String) : String :=
  let (out, _) := phrase.foldl (fun (state : Array Char × Nat) c =>
    let (arr, cnt) := state
    let lc := c.toLower
    let ch? : Option Char :=
      if lc.isAlpha then some (Char.ofNat ('z'.toNat + 'a'.toNat - lc.toNat))
      else if lc.isDigit then some lc
      else none
    match ch? with
    | none => state
    | some ch =>
      if cnt == 5 then ((arr.push ' ').push ch, 1)
      else (arr.push ch, cnt + 1)
  ) (#[], 0)
  String.ofList out.toList

def decode (phrase : String) : String :=
  let out := phrase.foldl (fun (arr : Array Char) c =>
    let lc := c.toLower
    if lc.isAlpha then arr.push (Char.ofNat ('z'.toNat + 'a'.toNat - lc.toNat))
    else if lc.isDigit then arr.push lc
    else arr
  ) #[]
  String.ofList out.toList

end AtbashCipher
