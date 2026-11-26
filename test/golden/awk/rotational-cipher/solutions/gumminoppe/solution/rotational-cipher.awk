BEGIN { FS = ""; U = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; L = tolower(U) }
{
  for (i = 1; i <= NF; ++i)
    result = result \
      ( $i ~ /[A-Z]/ ? substr(U, (index(U, $i) + distance - 1) % 26 + 1, 1) \
      : $i ~ /[a-z]/ ? substr(L, (index(L, $i) + distance - 1) % 26 + 1, 1) \
      : $i )
  print result
}
