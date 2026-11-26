.value as $v |
def find:
  if . == [] then
    "value not in array" | halt_error
  else
    ((length - 1) / 2 | floor) as $idx |
    if .[$idx] == $v then $idx
    elif .[$idx] > $v then .[:$idx] | find
    else .[$idx+1:] | find + $idx - 1 end
  end;

.array | find