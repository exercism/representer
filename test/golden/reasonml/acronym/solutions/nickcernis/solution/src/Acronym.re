let abbreviate = word => {
  let re = [%re "/\\b([a-z])/gi"];
  let letters = Js.String.match(re, word);
  switch (letters) {
  | None => ""
  | Some(letters) => Js.Array.joinWith("", letters) |> Js.String.toUpperCase
  };
};