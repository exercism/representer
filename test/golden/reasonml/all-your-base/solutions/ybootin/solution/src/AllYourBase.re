let rec fromBase10 = (base, x) => {
  switch (x mod base ) {
  | _ when x === 0 => []
  | z => Belt.List.concat(fromBase10(base, (x - z) / base), [z])
  }
}

let toBase10 = (base, digits) => {
  digits |> Belt.List.length |> fun 
  | len => digits -> Belt.List.reduceWithIndex(Some(0), (acc, head, index) => {
    switch (acc) {
      | None => None
      | Some(_) when head < 0 || base <= 0 || head >= base => None
      | Some(v) => Some(v + (head * Js.Math.pow_int(~base=base, ~exp=(len - index))))
      }
    }) |> fun 
    | None => None
    | Some(v) when v === 0 || len === 0 => None
    | Some(v) => Some(v / base)
}

let rebase = (a, digits, b) => digits |> toBase10(a) |> fun
  | None => None
  | Some(_) when b <= 0 => None
  | Some(x) => Some(x |> fromBase10(b))
