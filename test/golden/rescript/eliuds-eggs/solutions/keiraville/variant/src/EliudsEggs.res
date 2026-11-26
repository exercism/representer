let rec count = (n, acc) => if n !== 0 { acc } else { count(n - (n &&& -n), acc + 1) }

let eggCount = n => count(n, 0)
