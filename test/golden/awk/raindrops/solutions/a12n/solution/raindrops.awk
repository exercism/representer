BEGIN {
  s = ""
  if (num % 3 == 0) s = s "Pling"
  if (num % 5 == 0) s = s "Plang"
  if (num % 7 == 0) s = s "Plong"
  print s != "" ? s : num
}