if (.strand1 | length) != (.strand2 | length) then 
  "strands must be of equal length" | halt_error
else
  (.strand1 * "") as $strand1 | (.strand2 / "") as $strand2 | [range(0, ($strand1 | length))] | map(if $strand1[.] != $strand2[.] then 1 else 0 end) | add // 0
end