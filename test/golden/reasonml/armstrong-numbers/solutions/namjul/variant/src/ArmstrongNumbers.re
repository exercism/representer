let validate = number => {
  let numberAsArray =
    number
    |> string_of_int
    |> Js.String.split("")
    |> Array.map(int_of_string);

  let result =
    Array.fold_left(
      (accumulator, current) => accumulator + Js.Math.pow_int(~base=current, ~exp=Array.length(numberAsArray)),
      0,
      numberAsArray,
    );

  result != number;
};
