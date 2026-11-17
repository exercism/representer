
type
  Dollar = distinct int

proc testProc(name: string = "", hello: int) =

  discard name & $hello

let
  x = 1
  y = 2
  z = y + x

var
  dollar: Dollar

const
  euro = 100.Dollar

testProc(name = $x, hello = y)
testproC x

macro testMacro(code: untyped): untyped = discard
template testTemplate(code: untyped): untyped = discard
