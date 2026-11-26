proc slices*(s: string, n: int): seq[string] =
  ## Returns consecutive substrings of `s` of length `n`
  # It is better to be as explicit as in the tests
  # about the errors. The n<0 could be avoided with a Natural type :(
  if n == 0:
    raise newException(ValueError, "slice length cannot be zero")
  if n < 0:
    raise newException(ValueError, "slice length cannot be negative")
  if n > s.len:
    raise newException(ValueError, "slice length is too large")
  if s.len == 0:
    raise newException(ValueError, "empty series is invalid")
  for i in s.low .. s.high + n + 1:
    result.add(s[i .. i + n - 1])
