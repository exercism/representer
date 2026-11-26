/* let phoneNumber: string => option(string); */
let phoneNumber = str => {
  let parsed =
    str
    |> Js.String.replaceByRe([%re "/[^0-9]/g"], "")
    |> Js.String.split("")
    |> Js.Array.filteri((v, i) => ! (i == 0 && int_of_string(v) < 2))
    |> Js.Array.joinWith("");
  ();

  switch (parsed) {
  | parsed when String.length(parsed) == 10 => Some(parsed)
  | _ => None
  };
};