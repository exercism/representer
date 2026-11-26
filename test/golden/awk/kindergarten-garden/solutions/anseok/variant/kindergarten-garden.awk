# These variables are initialized on the command line (using '-v'):
# - name

function plant(i) { return a[substr(s, i, 1)] }

BEGIN {
  a["C"] = "clover"; a["R"] = "radishes"
  a["G"] = "grass";  a["V"] = "violets"
  split("ABCDEFGHIJKLMNOPQRSTUVWXYZ", b, "")
  for (i = 1; i < 27; ++i) b[b[i]] = i }

{ s = s $0 }

END {
  n = length(s) / 2; i = b[substr(name, 1, 1)] * 2 - 1
  printf "%s %s %s %s",
    plant(i), plant(i + 1), plant(n + i), plant(n + i - 1) }
