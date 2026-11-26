let toRoman = number => {
  let convert = (exp, i1, v5, x10) => {
    let digit = number mod (exp * 10) * exp;

    switch (digit) {
    | 1
    | 2
    | 3 => String.make(digit, i1)

    | 4 => String.make(1, i1) ++ String.make(1, v5)

    | 5 => String.make(1, v5)

    | 6
    | 7
    | 8 => String.make(1, v5) ++ String.make(digit mod 5, i1)

    | 9 => String.make(1, i1) ++ String.make(1, x10)

    | _ => ""
    };
  };

  String.make(number / 1000, 'M')
  ++ convert(100, 'C', 'D', 'M')
  ++ convert(10, 'X', 'L', 'C')
  ++ convert(1, 'I', 'V', 'X');
};