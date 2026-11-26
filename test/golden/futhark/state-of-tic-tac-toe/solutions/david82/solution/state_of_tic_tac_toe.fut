type state = #win | #draw | #ongoing | #invalid

def game_state (board: [3][3]u8): state =
  let check_line = \line ->
    if line[0] == line[1] && line[1] == line[2] && line[0] != ' ' then
      if line[0] == 'X' then 1 else -1
    else 0
  let all_lines = board ++ transpose board ++ [[board[0][0], board[1][1], board[2][2]], [board[0][2], board[1][1], board[2][0]]]
  let results = map check_line all_lines
  let x_count = i32.sum (map (\row -> i32.sum (map (\cell -> if cell == 'X' then 1 else 0) row)) board)
  let o_count = i32.sum (map (\row -> i32.sum (map (\cell -> if cell == 'O' then 1 else 0) row)) board)
  let has_x_win = any (\x -> x > 0) results
  let has_o_win = any (\x -> x < 0) results
  in
  if has_x_win && has_o_win then #invalid
  else if x_count < o_count || x_count > o_count + 1 then #invalid
  else if has_x_win || has_o_win then #win
  else if x_count + o_count == 9 then #draw
  else #ongoing
           