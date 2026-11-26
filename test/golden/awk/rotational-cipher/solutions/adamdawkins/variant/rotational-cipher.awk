@load "ordchr"
# These variables are initialized on the command line (using '-v'):
# - distance

BEGIN {
   FS = ""
   OFS = ""

  A = 65
  Z = 90
  a = 97
  z = 122
  }


{
  for(i=1; i<=NF;i++) {

    if ($i ~ /[a-zA-Z]/) {
      $i = chr(rotate_letter(ord($i), distance))
    }
  }

  print
}

#        rotate_letter :: LetterOrd -> num -> LetterOrd
function rotate_letter(current, _distance) {
  if (current <= Z)  {
    return _rotate(current, _distance, A)
  } else {
    return _rotate(current, _distance, a)
  }
}

function _rotate(current, _distance, start) {
  return (current - start + distance) % 26 - start
}
