-- Define digit patterns
let patterns: []([][]u8, u8) = [
  ([[' ', '_', ' '], ['|', ' ', '|'], ['|', '_', '|'], [' ', ' ', ' ']], '0'),
  ([[' ', ' ', ' '], [' ', ' ', '|'], [' ', ' ', '|'], [' ', ' ', ' ']], '1'),
  ([[' ', '_', ' '], [' ', '_', '|'], ['|', '_', ' '], [' ', ' ', ' ']], '2'),
  ([[' ', '_', ' '], [' ', '_', '|'], [' ', '_', '|'], [' ', ' ', ' ']], '3'),
  ([[' ', ' ', ' '], ['|', '_', '|'], [' ', ' ', '|'], [' ', ' ', ' ']], '4'),
  ([[' ', '_', ' '], ['|', '_', ' '], [' ', '_', '|'], [' ', ' ', ' ']], '5'),
  ([[' ', '_', ' '], ['|', '_', ' '], ['|', '_', '|'], [' ', ' ', ' ']], '6'),
  ([[' ', '_', ' '], [' ', ' ', '|'], [' ', ' ', '|'], [' ', ' ', ' ']], '7'),
  ([[' ', '_', ' '], ['|', '_', '|'], ['|', '_', '|'], [' ', ' ', ' ']], '8'),
  ([[' ', '_', ' '], ['|', '_', '|'], [' ', '_', '|'], [' ', ' ', ' ']], '9')
]

-- Check if grids match
let grids_match (a: [][]u8) (b: [][]u8): bool =
  length a == 4 && length b == 4 && all (\i -> all (\j -> a[i][j] == b[i][j]) (iota 3)) (iota 4)

-- Main conversion function
def convert (rows: [][]u8): []u8 =
  let num_rows = length rows
  let num_cols = if num_rows > 0 then length rows[0] else 0
  let valid = num_rows > 0 && num_rows % 4 == 0 && num_cols > 0 && num_cols % 3 == 0 &&
              all (\row -> length row == num_cols) rows
  in if !valid then rows[100]
     else
       let num_lines = num_rows / 4
       let num_digits = num_cols / 3
       let line_results = map (\line ->
         let start_row = i32.i64 line * 4
         in map (\digit ->
           let start_col = i32.i64 digit * 3
           let subgrid = map (\i -> 
             let row_idx = start_row + i32.i64 i
             let col_start = i64.i32 start_col
             in [rows[row_idx][col_start], rows[row_idx][col_start+1], rows[row_idx][col_start+2]]
           ) (iota 4)
           let matches = filter (\(pattern, _) -> grids_match pattern subgrid) patterns
           in if length matches > 0 then matches[0].1 else '?'
         ) (iota num_digits)
       ) (iota num_lines)
       in if num_lines == 1 then line_results[0]
          else loop acc = line_results[0] for i in 1..<num_lines do
            concat acc (concat [','] line_results[i])
               