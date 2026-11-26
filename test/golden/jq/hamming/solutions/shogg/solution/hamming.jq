if (.strand1|length) != (.strand2|length) then
  "strands must be of equal length" | halt_error
end
| [.strand1, .strand2] as [$s1, $s2]
| reduce range($s1|length) as $i (
    0;
    if $s1[$i:$i+1] != $s2[$i:$i+1] then . += 1 end
  )
