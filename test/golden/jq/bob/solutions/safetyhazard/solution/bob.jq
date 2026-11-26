.heyBob |
test("\\?\\s*$") as $question |
test("^(?=.*[A-Z])[^a-z]*$") as $yells |
if $question and $yells then "Calm down, I know what I'm doing!"
elif $question then "Sure."
elif $yells then "Whoa, chill out!"
elif test("^\\s*$") then "Fine. Be that way!"
else "Whatever." end
