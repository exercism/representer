def count_eggs:
  . as [$number, $acc] |
  if $number == 0 then $acc                     
  else [$number / 2, $number % 2 + $acc] | count_eggs
  end;

[.number, 0] | count_eggs
