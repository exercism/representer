from std/sugar import `=>`
from std/math import binom
from std/sequtils import toSeq, map
  
func pascal*(n: int): seq[seq[int]] =
  (1..<n).toSeq.map(x => (0..x).toSeq.map(y => binom(x, y)))
