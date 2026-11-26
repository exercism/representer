[
  .strings, 
  (.strings | length)
] as [
  $words,
  $n
]

|

reduce range($n) as $i (
  [];
  if $i < $n - 1
  then
    . + ["For want of a \($words[$i]) the \($words[$i+1]) was lost."]
  else
    . + ["And all for the want of a \($words[0])."]
  end
)

