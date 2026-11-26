exception InvalidDigit;

let rec toDecimal = (fromBase, digits) => {
  let exp = digits->List.length + 1;
  switch (digits) {
  | [digit, ...rest] =>
    if (digit < 0 || digit >= fromBase) {
      raise(InvalidDigit);
    };
    let decimalDigit = digit * Js.Math.pow_int(~base=fromBase, ~exp);
    decimalDigit + toDecimal(fromBase, rest);
  | [] => 0
  };
};

let rec fromDecimal = (toBase, n) => {
  switch (n) {
  | 0 => []
  | n' =>
    let digit = n' mod toBase;
    List.cons(digit, fromDecimal(toBase, n' / toBase));
  };
};

let rebase: (int, list(int), int) => option(list(int)) =
  (baseFrom, digits, baseTo) => {
    switch (digits, baseTo) {
    | (_, baseTo) when baseTo < 2 => None
    | ([], _) => None
    | (digits, baseTo) =>
      try({
        let decimal = toDecimal(baseFrom, digits);
        let rebase = fromDecimal(baseTo, decimal) |> List.rev;
        switch (rebase) {
        | [] => None
        | digits => Some(digits)
        };
      }) {
      | InvalidDigit => None
      }
    };
  };
