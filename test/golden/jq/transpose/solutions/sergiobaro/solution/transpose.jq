def fill_col(row_length; row_max):
  reduce range(row_length; row_max) as $index (.; .[$index] |= . + " ") 
;

def transpose_cols(row_length):
  .row_max as $row_max |
  if .result | length == 0 
  then .row | fill_col(row_length; $row_max)
  elif .row | length == 0
  then .result | fill_col(row_length; $row_max)
  else . as {row: $row, index: $index} | {
    row: .row[1:],
    index: (.index + 1),
    row_max: .row_max,
    result: (.result | .[$index] |= (. + $row[0]))
  } | transpose_cols(row_length)
  end
;

def transpose_rows:
  if .rows | length == 0 
  then .result
  else 
    (.rows[0] | length) as $row_length
    | {
      rows: .rows[1:],
      result: {
        row: (.rows[0] / ""),
        row_max: (.rows[1:] | map(length) | max // 0),
        index: 0,
        result: .result
      } | transpose_cols($row_length)
    } | transpose_rows
  end
;

{
  rows: .lines,
  result: []
}
| transpose_rows
