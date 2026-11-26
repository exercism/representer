.strings as $strings |
if ($strings | length) == 0 then
  []
elif ($strings | length) == 1 then
  ["And all for the want of a \($strings[0])."]
else
  ([range(0; ($strings | length) - 1) | 
    "For want of a \($strings[.]) the \($strings[. + 1]) was lost."] + 
  ["And all for the want of a \($strings[0])."])
end