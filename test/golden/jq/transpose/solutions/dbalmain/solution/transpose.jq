.lines
| map(./"") as $rows
| $rows
| if . == [] then
    []
  else
    map(length)
    | max
    | reduce range(.) as $i
      ([]; . + [
        $rows[0:
          $rows
          | to_entries
          | map(select(.value | length > $i) | .key)
          | last + 1
        ]
        | map(.[$i] // " ")
        | join("")
      ])
  end
