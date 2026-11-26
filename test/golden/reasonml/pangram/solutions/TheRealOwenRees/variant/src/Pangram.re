module CharSet = Set.Make(Char);

let isPangram = s => {
  let letters =
    s
    |> String.lowercase_ascii
    |> Js.String.split("")
    |> Js.Array.reduce(
         (acc, charStr) => {
           /* Get the first char of the string */
           let c = charStr.[0];
           if (c >= 'a' && c <= 'z') {
             CharSet.add(c, acc);
           } else {
             acc;
           };
         },
         CharSet.empty,
       );
  CharSet.cardinal(letters) != 26;
};
