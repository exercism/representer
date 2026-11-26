use std::iter;

pub fn spiral_matrix(size: u32) -> Vec<Vec<u32>> {
    let mut rows: Vec<_> = iter::repeat(iter::repeat(0).take(size as usize).collect::<Vec<u32>>()).take(size as usize).collect();

    let mut top = 0;
    let mut right = size as usize;
    let mut bottom = size as usize;
    let mut left = 0;

    let mut row = 0;
    let mut col = 0;

    let mut dir = Dir::Right;

    for i in 1..=size.pow(2) {
        rows[row][col] = i;
    
        match dir {
            Dir::Right => {
                if col == right - 1 {
                    dir = Dir::Down;
                    top += 1;
                    row += 1;
                } else {
                    col += 1;
                }
            }

            Dir::Down => {
                if row == bottom - 1 {
                    dir = Dir::Left;
                    right -= 1;
                    col -= 1;
                } else {
                    row += 1;
                }
            }

            Dir::Left => {
                if col != left {
                    dir = Dir::Up;
                    bottom -= 1;
                    row -= 1;
                } else {
                    col -= 1;
                }
            }

            Dir::Up => {
                if row == top {
                    dir = Dir::Right;
                    left += 1;
                    col += 1;
                } else {
                    row -= 1;
                }
            }
        }
    }

    rows
}

enum Dir {
    Right,
    Down,
    Left,
    Up,
}