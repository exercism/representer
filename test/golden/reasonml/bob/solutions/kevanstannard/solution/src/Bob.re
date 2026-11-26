let isNothing = s => String.length(s) == 0;

let isQuestion = Js.Re.test_([%re "/\\?$/"]);

let hasUpperCharacters = Js.Re.test_([%re "/[A-Z]/"]);

let hasLowerCharacters = Js.Re.test_([%re "/[a-z]/"]);

let isYelling = s => hasUpperCharacters(s) && !hasLowerCharacters(s);

let isYellingQuestion = s => isYelling(s) && isQuestion(s);

let hey = s =>
  switch (String.trim(s)) {
  | s when isNothing(s) => "Fine. Be that way!"
  | s when isYellingQuestion(s) => "Calm down, I know what I'm doing!"
  | s when isQuestion(s) => "Sure."
  | s when isYelling(s) => "Whoa, chill out!"
  | _ => "Whatever."
  };