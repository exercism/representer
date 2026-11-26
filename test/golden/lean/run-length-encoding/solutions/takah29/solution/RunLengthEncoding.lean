namespace RunLengthEncoding

def encode (string : String) : String := Id.run do
  if string.isEmpty then return ""

  let mut current_c := string.front
  let mut count := 0
  let mut result := ""

  for s in string ++ "." do
    if current_c == s then
      count := count + 1
    else
      if count > 1 then
        result := result ++ toString count
      result := result.push current_c
      current_c := s
      count := 1

  result


def decode (string : String) : String := Id.run do
  let mut countBuf := ""
  let mut result := ""

  for s in string do
    if s.isDigit then
      countBuf := countBuf.push s
    else
      let count := countBuf.toNat?.getD 1
      result := result.pushn s count
      countBuf := ""

  result


end RunLengthEncoding
