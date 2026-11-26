BEGIN {
  getline digits
  if(match(digits, "[^0-9 ]")) {
    print "false"
    exit
  }

  gsub(" ", "", digits)
  if(length(digits) < 2) {
    print "false"
    exit
  }

  split(digits, arr, "")
  for(i = length(arr) - 1; i > 0; i -= 2) {
    n = arr[i] / 2
    if(n > 9)
      n -= 9
    arr[i] = n
  }
  for(i = 1; i <= length(arr); i++) {
    cksum += arr[i]
  }

  if(cksum % 10 == 0)
    print "true"
  else
    print "false"
}
