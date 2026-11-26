let endsWithQuestionMark = [%bs.re "/\\?\\s*$/"];
let uppers = [%bs.re "/[A-Z]/"];
let lowers = [%bs.re "/[a-z]/"];

let uppercase = s => Js.Re.test(s, uppers);

let lowercase = s => Js.Re.test(s, lowers);

let question = s => Js.Re.test(s, endsWithQuestionMark);

let hey = remark =>
  if (String.trim(remark) == "") {
    "Fine. Be that way!";
  } else if (uppercase(remark) && ! lowercase(remark)) {
    if (question(remark)) {
      "Calm down, I know what I'm doing!";
    } else {
      "Whoa, chill out!";
    };
  } else if (question(remark)) {
    "Sure.";
  } else {
    "Whatever.";
  };
