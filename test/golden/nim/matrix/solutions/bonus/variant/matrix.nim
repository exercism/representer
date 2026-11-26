import strutils, sequtils


proc row*(m: string, row: int): seq[int] =
  let rows = m.splitLines()
  result = rows[row-1].split.mapIt(parseInt($it))

proc column*(m: string, col: int): seq[int] =
  let rows = m.splitLines()
  for r in rows:
    let cur_row = row(r, 2)
    result.add(cur_row[col-1])