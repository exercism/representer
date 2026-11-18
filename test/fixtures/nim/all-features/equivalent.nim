type Cash = distinct int

proc runIt(label: string = "", amount: int) =
  discard label & $amount

let
  a = 1
  b = 2
  c = b + a

var wallet: Cash

const pounds = 100.Cash

runIt(label = $a, amount = b)
run_it a

macro makeMacro(body: untyped): untyped = discard
template makeTemplate(body: untyped): untyped = discard
