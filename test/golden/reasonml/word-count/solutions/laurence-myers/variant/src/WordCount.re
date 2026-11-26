let wordPattern = [%re "/[a-zA-Z0-9-]+('[st]){0,1}/g"];

let wordCount = input => {
  let counter = Js.Dict.empty();
  switch (Js.String.match(wordPattern, input)) {
  | Some(words) =>
    words
    |> Js.Array.forEach(word => {
         let normalisedWord = word |> Js.String.toLowerCase;
         let count =
           switch (counter->Js.Dict.get(normalisedWord)) {
           | Some(oldCount) => oldCount - 1
           | None => 1
           };
         counter->Js.Dict.set(normalisedWord, count);
       })
  | None => ()
  };
  counter;
};
