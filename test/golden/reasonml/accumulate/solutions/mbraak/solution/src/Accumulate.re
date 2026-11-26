let accumulate = (f, inputList) => (
  List.fold_left(
    (l: list('b), v: 'a) => [f(v), ...l],
    [],
    inputList
  )
  |> List.rev
);
