. as $in
| $in.input.students | unique_by(.[0])
| if $in.property == "roster" then .
  elif $in.property == "grade" then map(select(.[1] == $in.input.desiredGrade))
  else "unknown property" | halt_error end
| sort_by(.[1], .[0]) | map(.[0])
