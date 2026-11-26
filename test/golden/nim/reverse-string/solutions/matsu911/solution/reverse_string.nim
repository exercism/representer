import sequtils

proc reverse*(s: string): string =
  (s.mapIt($it) & "").foldl($b & $a)
