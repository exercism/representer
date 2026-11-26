let numerals = [
  ('I', 1);
  ('V', 5);
  ('X', 10);
  ('L', 50);
  ('C', 100);
  ('D', 500);
  ('M', 1000)
]

let rec int_parts i =
  let rec power i j =
    if j = 0 then 1
    else i * (power i (j - 1)) in
  if i = 0 then []
  else if i < 10 then [i]
  else
    let places = i |> float_of_int |> log10 |> int_of_float in
    let tens = power 10 places in
    [i / tens * tens] @ int_parts (i mod tens)

let to_roman i =
  let nearest_numeral i =
    List.sort (fun (_, v) (_, v') -> abs(v - i) - abs(v' - i)) numerals |> List.hd in
  let rec to_roman' l i =
    let (symbol, value) = nearest_numeral i in
    if i = 0 then l
    else if i = 8 then ['V'; 'I'; 'I'; 'I']
    else if i - value = 0 then l @ [symbol]
    else if i - value > 0 then l @ [symbol] @ (to_roman' [] (i - value))
    else l @ (to_roman' [] (value - i)) @ [symbol] in
  int_parts i |> List.map (fun i -> to_roman' [] i) |> List.flatten |> List.to_seq |> String.of_seq
