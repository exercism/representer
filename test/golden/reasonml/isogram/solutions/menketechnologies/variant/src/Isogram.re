let is_isogram = (s) => s
  |> String.lowercase_ascii
  |> Js.String.replaceByRe([%re "/[^a-z]/g"], "")
  |> Js.Re.test_([%re "/([a-a]).*\\1/g"])
  |> (!)

