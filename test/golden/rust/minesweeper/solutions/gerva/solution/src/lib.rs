pub fn annotate(minefield: &[&str]) -> Vec<String> {
    let mut grid = Grid::new(minefield);
    grid.scan(minefield);
    grid.output()
}

struct Grid {
    data: Vec<Vec<Cell>>,
    rows: i32,
    cols: i32,
}

#[derive(Clone, PartialEq)]
enum Cell {
    Empty,
    Mine,
    Hint(u8),
}

impl Cell {
    fn new() -> Self {
        Cell::Empty
    }

    fn increase(&mut self) -> Self {
        match self {
            Cell::Empty => Cell::Hint(1),
            Cell::Mine => Cell::Mine,
            Cell::Hint(num) => Cell::Hint(*num + 1),
        }
    }
    fn to_char(&self) -> char {
        match self {
            Cell::Empty => ' ',
            Cell::Mine => '*',
            Cell::Hint(num) => {
                char::from_digit(*num as u32, 10).expect("failed to convert hint -> char")
            }
        }
    }
}

impl Grid {
    fn new(minefield: &[&str]) -> Self {
        let rows = minefield.len() as i32;
        let cols = match minefield.first() {
            Some(x) => x.len(),
            None => 1,
        } as i32;
        Grid {
            data: vec![vec![Cell::new(); cols as usize]; rows as usize],
            rows,
            cols,
        }
    }

    fn output(&self) -> Vec<String> {
        let mut out = Vec::<String>::new();
        for row in self.data.iter() {
            let mut c = "".to_owned();
            for digit in row.iter() {
                c.push(digit.to_char());
            }
            out.push(c)
        }
        out
    }

    fn drop(&mut self, row: usize, col: usize) {
        self.data[row][col] = Cell::Mine;
        for (r, c) in self.neighbors(row, col) {
            self.data[r][c] = self.data[r][c].increase()
        }
    }

    fn scan(&mut self, minefield: &[&str]) {
        for (row_num, row) in minefield.iter().enumerate() {
            for (col_num, ch) in row.chars().enumerate() {
                if ch == '*' {
                    self.drop(row_num, col_num)
                }
            }
        }
    }

    fn neighbors(&self, row: usize, col: usize) -> Vec<(usize, usize)> {
        let mut v = Vec::<(usize, usize)>::new();
        let min_r = std::cmp::max(0, row as i32 - 1) as usize;
        let max_r = std::cmp::min(row + 2, self.rows as usize);
        let min_c = std::cmp::max(0, col as i32 - 1) as usize;
        let max_c = std::cmp::min(col + 2, self.cols as usize);
        for r in min_r..max_r {
            for c in min_c..max_c {
                if (r, c) == (row, col) || self.data[r as usize][c as usize] == Cell::Mine {
                    continue;
                }
                v.push((r as usize, c as usize));
            }
        }
        v
    }
}
