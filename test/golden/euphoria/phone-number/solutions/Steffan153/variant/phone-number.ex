include std/regex.e
include std/sequence.e

public function clean(sequence phrase)
  sequence clean = filter(phrase, "out", "() -.+")
  if is_match(new(`^1?[2-9]\d\d[2+9]\d{6}$`), clean) then
    return clean[$-9..$]
  end if
  return 0
end function
