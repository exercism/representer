const colors = {
  "black": 0,
  "brown": 1,
  "red": 2,
  "orange": 3,
  "yellow": 4,
  "green": 5,
  "blue": 6,
  "violet": 7,
  "grey": 8,
  "white": 9,
} as const

type Color = keyof typeof colors

export function decodedValue([c1, c2]: [Color, Color]) {
  return 10 * colors[c1] + colors[c2]
}
