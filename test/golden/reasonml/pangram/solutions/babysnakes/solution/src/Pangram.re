let rec range = (start: int, end_: int) =>
  start >= end_ ? [] : [start, ...range(start + 1, end_)];

let isPangram = input => {
  let lcs = String.lowercase(input);
  range(97, 122)
  |> List.map(n => Js.String.fromCharCode(n))
  |> List.for_all(s => Js.String.includes(s, lcs));
};