module main

const (
    side_none = 0
    side_opposite = 1
    side_top = 2
    side_bottom = 3
    side_left = 4
    side_right = 5
)

struct Cell {
    row    int
    column int
    side   int = side_none
}

// Representing deltas for each direction: left, right, up, down, up-right, down-left.
const deltas = [
    Cell{row: 0, column: -1, side: side_none},
    Cell{row: 0, column: 1, side: side_none},
    Cell{row: -1, column: 0, side: side_none},
    Cell{row: 1, column: 0, side: side_none},
    Cell{row: -1, column: 1, side: side_none},
    Cell{row: 1, column: -1, side: side_none},
]

fn init_pending(row_count int, column_count int) []Cell {
    mut pending := []Cell{cap: (row_count + 2) * (column_count + 2)}
    for i in 0 .. column_count + row_count {
        pending << Cell{ if i < column_count { -1 } else { i - column_count }, if i <= column_count { i } else { -1 }, if i < column_count { side_top } else { side_left } }
        pending << Cell{ if i < column_count { row_count } else { i - column_count }, if i < column_count { i } else { column_count }, if i < column_count { side_bottom } else { side_right } }
    }
    return pending
}

fn winner(board []string) ?rune {
    row_count := board.len
    column_count := (board[0].len + 1) >> 1
    mut pending := init_pending(row_count, column_count)
    mut reached := [][]int{len: row_count, init: []int{len: column_count, init: side_none}}

    for pending.len > 0 {
        current := pending.pop()
        player := if current.side <= side_bottom { `O` } else { `X` }

        for delta in deltas {
            row, column := current.row + delta.row, current.column + delta.column

            if row < 0 || row >= row_count || column < 0 || column >= column_count || board[row][row + 2 * column] != player {
                continue
            }

            if reached[row][column] == side_none {
                reached[row][column] = current.side
                pending << Cell{row, column, current.side}
            } else if reached[row][column] == current.side ^ side_opposite {
                return player
            }
        }
    }

    return none
}
