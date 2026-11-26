function mmi(a, m,  t, nt, r, nr, q, tmp) {
  t = 0; nt = 1; r = m; nr = a % m
  while (nr != 0) {
    q = int(r / nr)
    tmp = nt; nt = t - q * nt; t = tmp
    tmp = nr; nr = r - q * nr; r = tmp }
  if (t < 0) t += m; return t }

function mod(n) { n %= 26; return n < 0 ? n + 26 : n }

BEGIN {
  split("bcdefghijklmnopqrstuvwxyz", a, ""); a[0] = "a"
  for (i = 0; i < 26; ++i) a[a[i]] = i; FS = "|" }

{ i = $2; j = 26
  while (i) { c = j; j = i; i = c % i }
  if (j > 1) { print "a and m must be coprime."; e = 1; exit }
  gsub(/[^[:alnum:]]+/, "", $4) }

$1 == "encode" {
  $4 = tolower($4)
  for (i = length($4); i > 0; --i) {
    c = substr($4, i, 1)
    s = (c ~ /[a-z]/ ? a[mod($2 * a[c] + $3)] : c) s }
  gsub(/...../, "& ", s); gsub(/ $/, "", s); next }

{ $2 = mmi($2, 26)
  for (i = length($4); i > 0; --i) {
    c = substr($4, i, 1)
    s = (c ~ /[a-z]/ ? a[mod($2 * (a[c] - $3))] : c) s } }

END { if (e) exit e; print s }
