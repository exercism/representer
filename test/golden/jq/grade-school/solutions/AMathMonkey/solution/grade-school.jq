def all_names($sort):
  . as $in | keys_unsorted
  | if $sort then sort_by(tonumber) end
  | map($in[.]) | flatten;

def grades:
  reduce .[] as [$name, $grade] ({};
    if all_names(false) | index($name) | not then 
      .[$grade | tostring] |= (. // []) + [$name] 
    end) 
  | map_values(sort);

def grade($n):
  grades | .[$n | tostring] // [];

if .property == "roster" then
  .input.students | grades | all_names(true)
else
  .input as $i | $i.students | grade($i.desiredGrade)
end
