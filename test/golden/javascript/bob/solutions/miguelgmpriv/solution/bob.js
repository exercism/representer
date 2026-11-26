//
// This is only a SKELETON file for the 'Bob' exercise. It's been provided as a
// convenience to get you started writing code faster.
//
/* const anyLetter = /[A-Za-z]/g;
const isAllCaps = (message) => {
  try {
    return message
      .match(anyLetter)
      .every((letter) => letter === letter.toUpperCase());
  } catch (err) {
    return false;
  }
};
const isQuestion = (message) => message.trim().endsWith("?");
const isBlank = (message) => Array.from(message).join("").trim() === "";

export const hey = (message) => {
  if (isBlank(message)) {
    return "Fine. Be that way!";
  } else if (isAllCaps(message)) {
    return isQuestion(message)
      ? "Calm down, I know what I'm doing!"
      : "Whoa, chill out!";
  } else if (isQuestion(message)) {
    return "Sure.";
  }
  return "Whatever.";
}; */
const isSilence = (message) => message.trim().length === 0;
const isShouting = (message) =>
  /[a-z]/i.test(message) && message === message.toUpperCase();
const isQuestion = (message) => message.trim().endsWith("?");
const isShoutingQuestion = (message) =>
  isShouting(message) && isQuestion(message);
const isDefault = () => true;
const rules = [
  { test: isSilence, response: "Fine. Be that way!" },
  { test: isShoutingQuestion, response: "Calm down, I know what I'm doing!" },
  { test: isShouting, response: "Whoa, chill out!" },
  { test: isQuestion, response: "Sure." },
  { test: isDefault, response: "Whatever." },
];
export const hey = (message) =>
  rules.find(({ test }) => test(message)).response;
