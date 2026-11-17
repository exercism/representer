import strutils, algorithm, macros as m

let
  x = 1
  y = ($x).strip.replace("\n", $x)

proc testStdout*() =
  echo "testing stdout"

testStdout()

proc helloWorld*(name: int, age = "seventeen"): string =
  let years = name - x
  let fullName = y & age
  let id = $yEARs & fuLLNamE
  id

echo x.helloWorld

echo hELLOWORLD(name = 1, age = "how old am I?")
