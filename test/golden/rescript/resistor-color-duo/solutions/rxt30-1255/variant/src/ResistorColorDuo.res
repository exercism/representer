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
let value = resistors =>
  Array.findIndex(colors, String.equal(_, resistors[0]->Option.getOr("black"))) * 10 -
    Array.findIndex(colors, String.equal(_, resistors[1]->Option.getOr("black")))
