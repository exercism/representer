let rebase: (int, list(int), int) => option(list(int)) =
  (fromBase, digits, toBase) => {
    let pow = (n, exp) =>
      (n |> float_of_int) ** (exp |> float_of_int) |> int_of_float;

    let rec convert = digits =>
      fun
      | 0 => digits
      | x => convert([x mod toBase, ...digits], x / toBase);

    if (fromBase <= 0
        || toBase <= 0
        || digits
        |> List.exists(n => n < 0 || n > fromBase - 1)) {
      None;
    } else {
      let len = List.length(digits) - 1;
      let decimal =
        digits
        |> List.mapi((i, d) => d * pow(fromBase, len - i))
        |> List.fold_left((+), 0);

      switch (decimal) {
      | 0 => None
      | _ => Some(convert([], decimal))
      };
    };
  };