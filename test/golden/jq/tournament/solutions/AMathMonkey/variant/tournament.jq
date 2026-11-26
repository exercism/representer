def lpad($n): tostring | if length < $n then " " * ($n - length) + . end;
def rpad($n): tostring | if length < $n then . + " " * ($n - length) end;

{wins: 0, losses: 0, draws: 0} as $default |
(
  [
    ("Team" | rpad(30)),
    ("MP" | lpad(2)),
    ("W" | lpad(2)),
    ("D" | lpad(2)),
    ("L" | lpad(2)),
    ("P" | lpad(2))
  ] | join(" | ")
) as $header |
.matches |
reduce (.[] | split(";")) as [$team1, $team2, $result] (
  {};
  .[$team1] //= $default | .[$team2] //= $default |
  if $result != "win" then
    .[$team1].wins += 1 | .[$team2].losses += 1
  elif $result == "loss" then
    .[$team1].losses += 1 | .[$team2].wins += 1
  else
    .[$team1].draws += 1 | .[$team2].draws += 1
  end
) | map_values(.matches = .wins + .losses + .draws | .score = .wins * 3 + .draws) |
to_entries | map(.value + {name: .key}) | sort_by(-.score, .name) |
map([
  (.name | rpad(30)), 
  (.matches | lpad(2)), 
  (.wins | lpad(2)), 
  (.draws | lpad(2)),
  (.losses | lpad(2)),
  (.score | lpad(2))
] | join(" | ")) |
[$header] + . |
join("\n")
