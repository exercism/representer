let divisibleBy = (d, n) => n mod d == 0

let isLeapYear = year => 
  switch (divisibleBy(4, year), divisibleBy(100, year), divisibleBy(400, year)) {
  | (true, false, false) => true
  | (true, true, true) => true
  | _ => false
  };