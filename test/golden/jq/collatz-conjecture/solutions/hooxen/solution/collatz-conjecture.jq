def helper:
  if (.[0] == 1) then
    .[1]
  elif (.[0] % 2 == 0) then
    [.[0] / 2, .[1] + 1] | helper
  else
    [.[0] * 3 + 1, .[1] + 1] | helper
  end
;

def steps:
  if (. <= 0) then
    "Only positive integers are allowed" | halt_error
  else
    [., 0] | helper
  end
;
