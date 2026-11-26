fn thousands(number: Int) -> String {
  case number / 1000 {
    3 -> "MMM"
    2 -> "MM"
    1 -> "M"
    _ -> ""
  }
}

fn hundreds(number: Int) -> String {
  case { number % 1000 } / 100 {
    9 -> "CM"
    8 -> "DCCC"
    7 -> "DCC"
    6 -> "DC"
    5 -> "D"
    4 -> "CD"
    3 -> "CCC"
    2 -> "CC"
    1 -> "C"
    _ -> ""
  }
}

fn tens(number: Int) -> String {
  case { number % 100 } / 10 {
    9 -> "XC"
    8 -> "LXXX"
    7 -> "LXX"
    6 -> "LX"
    5 -> "L"
    4 -> "XL"
    3 -> "XXX"
    2 -> "XX"
    1 -> "X"
    _ -> ""
  }
}

fn ones(number: Int) -> String {
  case number % 10 {
    9 -> "IX"
    8 -> "VIII"
    7 -> "VII"
    6 -> "VI"
    5 -> "V"
    4 -> "IV"
    3 -> "III"
    2 -> "II"
    1 -> "I"
    _ -> ""
  }
}

pub fn convert(number: Int) -> String {
  thousands(number) <> hundreds(number) <> tens(number) <> ones(number)
}
