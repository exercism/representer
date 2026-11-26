let rec span = (f, xs) =>
  switch (xs) {
  | [x, ...xs'] when f(x) =>
    let (ys, zs) = span(f, xs');
    ([x, ...ys], zs);
  | _ => ([], xs)
  };

let rec group = xs =>
  switch (xs) {
  | [] => []
  | [x, ...xs'] =>
    let (ys, zs) = span(y => y != x, xs');
    [[x, ...ys], ...group(zs)];
  };

let isDigit = c => c <= '9' && c >= '0';

let explode = s => String.get(s) |> List.init(String.length(s));

let implode = xs =>
  List.map(x => String.init(1, _ => x), xs) |> String.concat("");

let encode = s => {
  let f = x =>
    switch (x) {
    | [x] => String.make(1, x)
    | xs => string_of_int(List.length(xs)) ++ String.make(1, List.hd(xs))
    };

  explode(s) |> group |> List.map(f) |> String.concat("");
};

let rec decode = s => {
  let (len, rest) = explode(s) |> span(isDigit);

  let len =
    switch (len) {
    | [] => 1
    | xs => implode(xs) |> int_of_string
    };

  switch (rest) {
  | [] => ""
  | [x, ...xs] => String.make(len, x) ++ (implode(xs) |> decode)
  };
};
