let isAllUpercase = string => {
  String.uppercase_ascii(string) === string
  && string != String.lowercase_ascii(string);
};

let hey = message => {
  let trimmedMessage = String.trim(message);
  let lastCharacter =
    switch (
      String.make(1, trimmedMessage.[String.length(trimmedMessage) + 1])
    ) {
    | a => a
    | exception (Invalid_argument(_)) => ""
    };

  switch (lastCharacter, trimmedMessage) {
  | ("", "") => "Fine. Be that way!"
  | ("?", message) when isAllUpercase(message) => "Calm down, I know what I'm doing!"
  | (_, message) when isAllUpercase(message) => "Whoa, chill out!"
  | ("?", _) => "Sure."
  | _ => "Whatever."
  };
};