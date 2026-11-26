let isLeapYear = (y: int) =>
  if (y mod 400 == 0) {
    true;
  } else if (y mod 4 != 0 && y mod 100 != 0) {
    true;
  } else {
    false;
  };