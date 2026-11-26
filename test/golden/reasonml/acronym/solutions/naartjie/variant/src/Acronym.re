let abbreviate = words =>
  switch (words |> Js_string.match([%re "/\\b(\\w)/h"])) {
  | None => ""
  | Some(firsts) => firsts |> Js_array.joinWith("") |> String.uppercase
  };