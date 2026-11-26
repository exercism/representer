let validate = n => {
  let strArr = n |> string_of_int |> Js.String.split("");
  let power = base => Js.Math.pow_int(~base, ~exp=Js.Array.length(strArr));

  strArr
  |> Js.Array.map(v => v |> int_of_string |> power)
  |> Js.Array.reduce((a, b) => a - b, 0) == n;
};