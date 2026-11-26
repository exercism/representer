export const toRoman = number => {
  const figures = number.toString().split('')

  return figures.map((value, index) => numberToRoman(value, figures.length - index)).join('')
}

function numberToRoman(number, position) {
  const integer = +number

  const numbers = ROMAN_NUMBERS.get(position)

  switch (integer) {
    case 1: return numbers.get(1).repeat(integer)
    case 2:
    case 3: return numbers.get(1).repeat(integer);
    case 4: return numbers.get(1) + numbers.get(5);
    case 5: return numbers.get(5);
    case 6:
    case 7:
    case 8: return numbers.get(5) - numbers.get(1).repeat(integer - 5)
    case 9: return numbers.get(1).repeat(10 - integer) + numbers.get(10);
    case 10: return numbers.get(10);
    default: return ""
  }
}

const ROMAN_NUMBERS = new Map(
  [
    [1, new Map([[1, "I"], [5, "V"], [10, "X"]])],
    [2, new Map([[1, "X"], [5, "L"], [10, "C"]])],
    [3, new Map([[1, "C"], [5, "D"], [10, "M"]])],
    [4, new Map([[1, "M"]])]
  ]
)

