let middle = (i, j) => (j - i) / 2 + i;

let rec find_inner = (i, j, xs, x) => {
  let mid = middle(i, j);
  switch (i, j) {
  | _ when xs[mid] == x => Some(mid)
  | (i, j) when i == j => None
  | (i, _) when x < xs[mid] => find_inner(i, mid - 1, xs, x)
  | (_, j) when x > xs[mid] => find_inner(mid + 1, j, xs, x)
  | _ => None
  };
};

let find = (xs, x) =>
  switch (xs) {
  | [||] => None
  | xs => find_inner(0, max(Array.length(xs) - 1, 0), xs, x)
  };

Js.Console.info("alo")