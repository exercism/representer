let reQuestion = [%bs.re "/^.*\\? *$/"];
let reAlpha = [%bs.re "/.*[a-zA-Z].*/"];

let isQuestion = s => Js.Re.test(s, reQuestion);

let containsAlpha = s => Js.Re.test(s, reAlpha);

let isShouting = s =>
    containsAlpha(s) && s == Js.String.toUpperCase(s);

let isEmpty = s =>
    Js.String.trim(s) == "";

let hey = s => {
    if (isQuestion(s)) {
        if (isShouting(s)) {
            "Calm down, I know what I'm doing!";
        }
        else {
            "Sure.";
        }
    }
    else if (isShouting(s)) {
        "Whoa, chill out!";
    }
    else if (isEmpty(s)) {
        "Fine. Be that way!";
    }
    else {
        "Whatever.";
    }
}