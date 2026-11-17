
import
  algorithm, macros as m, strutils

let
  placeholder_0 = 1
  placeholder_1 = `$`(placeholder_0).strip.replace("\n", `$`(placeholder_0))
proc placeholder_2*() =
  echo("testing stdout")

placeholder_2()
proc placeholder_5*(placeholder_3: int; placeholder_4 = "seventeen"): string =
  let placeholder_6 = `-`(placeholder_3, placeholder_0)
  let placeholder_7 = `&`(placeholder_1, placeholder_4)
  let placeholder_8 = `&`(`$`(placeholder_6), placeholder_7)
  placeholder_8

echo(placeholder_0.placeholder_5)
echo(placeholder_5(placeholder_3 = 1, placeholder_4 = "how old am I?"))
