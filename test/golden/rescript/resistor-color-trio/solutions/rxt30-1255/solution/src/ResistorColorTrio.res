let colors = [
  "black",
  "brown",
  "red",
  "orange",
  "yellow",
  "green",
  "blue",
  "violet",
  "grey",
  "white",
]
let label = resistors => {
  let first = Array.findIndex(colors, String.equal(_, resistors[0]->Option.getOr("black"))) * 10
  let second = Array.findIndex(colors, String.equal(_, resistors[1]->Option.getOr("black")))
  let factor = 10 ** Array.findIndex(colors, String.equal(_, resistors[2]->Option.getOr("black")))
  let sum = (first->BigInt.fromInt + second->BigInt.fromInt) * factor->BigInt.fromInt
  if sum > 1_000_000_000n {
    `${(sum / 1000000000n)->BigInt.toString} gigaohms`
  } else if sum > 1_000_000n {
    `${(sum / 1000000n)->BigInt.toString} megaohms`
  } else if sum > 1_000n {
    `${(sum / 1000n)->BigInt.toString} kiloohms`
  } else {
    `${sum->BigInt.toString} ohms`
  }
}
