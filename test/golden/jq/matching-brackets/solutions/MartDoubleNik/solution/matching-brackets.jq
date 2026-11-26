def is_open_par: . == "(" or . == "[" or . == "{";
def is_close_par: . == ")" or . == "]" or . == "}";
def closes($v): . == "(" and $v == ")" or . == "[" and $v == "]" or . == "{" and $v == "}";
.value / "" | map(select(is_open_par or is_close_par))
| reduce .[] as $v(
  [];
  if ($v | is_open_par) then . + [$v]
  elif ($v | is_close_par) and (.[-1] | closes($v)) then .[:-1]
  else . + [$v]
  end
) == []