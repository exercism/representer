let splitWhile = (xs: list('a), ~f: 'a => bool): (list('a), list('a)) => {
  let rec loop = (acc, xs): (list('a), list('a)) =>
    switch(xs) {
    | [hd, ...tl] when f(hd) => loop([hd, ...acc], tl)
    | t => (List.rev(acc), t)
    };

  loop([], xs);
};

let isDigit = (c: string): bool => {
  let code: int = Char.code(c.[0]);
  code >= Char.code('0') && code <= Char.code('9');
};

let takeNumber = (chars: list(string)): (int, list(string)) => {
  switch (splitWhile(chars, ~f=isDigit)) {
  | ([], restChars) => (1, restChars)
  | (digits, restChars) => (digits |> String.concat("") |> int_of_string, restChars)
  }
};

let rec repeatString = (n: int, s: string): string => {
  if (n == 1) {
    s;
  } else {
    s ++ repeatString(n - 1, s);
  }
};

let rec decodeChars = (chars: list(string)): list(string)  => {
  switch (takeNumber(chars)) {
  | (_, []) => []
  | (n, [c, ...rest]) => [repeatString(n, c), ...decodeChars(rest)]
  }
};

let decode = s =>
  Js.String.split("", s)
  |> Array.to_list
  |> decodeChars
  |> String.concat("")

let createSequence = (c: string, n: int): string => {
  switch (n) {
  | 0 => ""
  | 1 => c
  | _ => string_of_int(n) ++ c
  }
};

let rec encodeChars = (c: string, n: int, chars: list(string)) => {
  switch (chars) {
  | [] => [createSequence(c, n)]
  | [firstChar, ...restChars] when c == firstChar => encodeChars(c, n + 1, restChars)
  | [firstChar, ...restChars] => [createSequence(c, n), ...encodeChars(firstChar, 1, restChars)]
  }
};

let encode = s =>
  encodeChars(
    " ",
    0,
    Js.String.split("", s) |> Array.to_list
  ) |> String.concat("")
