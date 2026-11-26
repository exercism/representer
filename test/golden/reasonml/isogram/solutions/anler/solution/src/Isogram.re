let charCodeA = "a" |> Js.String.charCodeAt(0) |> int_of_float;

exception DuplicateFound;

let is_isogram = s => {
  let s = Js.String.toLowerCase(s);
  let alphabetSize = 26;
  let seen = Array.make(alphabetSize, false);
  let stop = String.length(s) - 1;

  try(
    {
      for (i in 0 to stop) {
        let idx = Js.String.charCodeAt(i, s)->int_of_float - charCodeA;
        if (idx >= 0 && idx < alphabetSize) {
          if (seen[idx]) {
            raise(DuplicateFound);
          } else {
            seen[idx] = true;
          };
        };
      };

      true;
    }
  ) {
  | DuplicateFound => false
  };
};
