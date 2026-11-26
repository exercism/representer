let nonDigit = [%bs.re "/[^0-9]+/g"];
let validPhoneNumber = [%bs.re "/^[2-9][0-9]{2}[2-9][0-9]{6}$/"];

let rec phoneNumber = number => {
  let digits = Js.String.replaceByRe(nonDigit, "", number);
  switch (String.length(digits)) {
  | 11 when Js.String.startsWith("1", digits) =>
    phoneNumber(Js.String.sliceToEnd(~from=2, digits))
  | 10 when Js.Re.test(digits, validPhoneNumber) => Some(digits)
  | _ => None
  };
};
