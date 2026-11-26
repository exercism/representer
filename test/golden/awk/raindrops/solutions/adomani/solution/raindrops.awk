# These variables are initialized on the command line (using '-v'):
# - num

BEGIN {
  str=""
  if (num % 3 == 0) str="Pling"
  if (num % 5 == 0) str=str "Plang"
  if (num % 7 == 0) str=str "Plong"
  if (! str) str=num
  print str
}
