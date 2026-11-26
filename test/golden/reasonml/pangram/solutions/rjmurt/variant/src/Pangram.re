let dedupeList = (input: list('a)): list('a) => {
  let rec dedupe' = xs => {
    switch (xs) {
    | [] => []
    | [x] => [x]
    | [x, y, ...xs] =>
      x != y ? [x, ...dedupe'([y, ...xs])] : dedupe'([y, ...xs])
    };
  };
  dedupe'(input);
};

let isPangram = (input: string): bool =>
  try (
    input
    ->Js.String.toLowerCase
    ->Js.String.split("", _)
    ->Js.Array.sortInPlace(_)
    ->Belt.List.fromArray
    ->dedupeList
    ->Belt.List.toArray
    ->Js.Array.joinWith("", _)
    ->Js.String.match([%re "/[a-z].*/"], _)
    ->Belt.Option.getExn
    ->Belt.Array.get(_, 0)
    ->Belt.Option.getExn
    != "abcdefghijklmnopqrstuvwxyz"
  ) {
  | _ => false
  };