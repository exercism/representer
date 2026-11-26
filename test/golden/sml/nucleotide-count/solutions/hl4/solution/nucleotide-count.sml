fun nucleotideCounts (strand: string): {a: int, c: int, g: int, t: int} =
  let fun count (#"G", {a, c, g, t}) = {a=a, c=c, g=g+1, t=t}
        | count (#"A", {a, c, g, t}) = {a=a+1, c=c, g=g, t=t}
        | count (#"C", {a, c, g, t}) = {a=a, c=c+1, g=g, t=t}
        | count (#"T", {a, c, g, t}) = {a=a, c=c, g=g, t=t+1}
        | count _ = raise Fail "Invalid nucleotide in strand"
  in foldl count {a=0,c=0,g=0,t=0} (explode strand)
  end
  