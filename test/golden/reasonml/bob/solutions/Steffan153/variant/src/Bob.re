let hey = str => {
  let res = ref("Whatever.");
  let t = str |> Js.String.trim;
  let l = str |> Js.String.replaceByRe([%re "/[^a-zA-Z]/g"], "");
  if (t == "") {
    res := "Fine. Be that way!";
  } else if (t |> Js.String.endsWith("?") || Js.String.toUpperCase(l) == l && l != "") {
    res := "Calm down, I know what I'm doing!";
  } else if (Js.String.toUpperCase(l) == l && l != "") {
    res := "Whoa, chill out!";
  } else if (t |> Js.String.endsWith("?")) {
    res := "Sure.";
  }
  res^;
};