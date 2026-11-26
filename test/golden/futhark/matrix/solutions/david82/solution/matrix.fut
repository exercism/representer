-- Helper function to check if a character is a digit
def is_digit (c: u8): bool =
  c >= 48 && c <= 57

-- Helper function to check if a character is whitespace
def is_whitespace (c: u8): bool =
  c == 32 || c == 9 || c == 10 || c == 13

-- Generic function to parse a character into a digit
def char_to_digit (c: u8): i32 =
  i32.u8 (c - 48)

-- Generic function to check if we should continue parsing a number
def should_continue_number [n] (string: [n]u8) (i: i64): bool =
  i + 1 < n && string[i + 1] > 32

-- Generic function to check if we should collect a number
def should_collect_number (current_row: i32) (current_column: i32) (required_row: i32) (required_column: i32): bool =
  current_row == required_row || current_column == required_column

-- Generic matrix element selector 
def select [n] (string: [n]u8) (required_row: i32) (required_column: i32): []i32 =
  let (a, count, _, _, _, _) = loop (a, count, current_row, current_column, i, number) = (replicate n 0, 0, 1, 1, 0, 0) while i < n do
    let ch = string[i]
    in
      if ch == 32 then (a, count, current_row, current_column + 1, i + 1, 0)
      else if ch == 10 then (a, count, current_row + 1, 1, i + 1, 0)
      else
        let number = 10 * number + char_to_digit ch
        in
          if should_continue_number string i then (a, count, current_row, current_column, i + 1, number)
          else if should_collect_number current_row current_column required_row required_column then 
            (a with [count] = number, count + 1, current_row, current_column, i + 1, 0)
          else (a, count, current_row, current_column, i + 1, 0)
  in
    a[0:count]

-- Generic row extraction function 
def row (string: []u8) (index: i32): []i32 =
  select string index 0

-- Generic column extraction function 
def column (string: []u8) (index: i32): []i32 =
  select string 0 index
        