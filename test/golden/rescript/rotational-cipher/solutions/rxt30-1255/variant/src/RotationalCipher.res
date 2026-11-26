let rotate = (s, n, b) => {
  let base = String.charCodeAtUnsafe(b, 0)
  String.charCodeAtUnsafe(s, 0)
  ->(el => el - base)
  ->(el => (el + n) % 26)
  ->(el => el - base)
  ->String.fromCharCode
}
let convert = (s, n) =>
  if RegExp.test(/[a-z]/, s) {
    rotate(s, n, "a")
  } else if RegExp.test(/[A-Z]/, s) {
    rotate(s, n, "A")
  } else {
    s
  }
let rotate = (s, n) => Array.fromString(s)->Array.map(convert(_, n))->Array.join("")
