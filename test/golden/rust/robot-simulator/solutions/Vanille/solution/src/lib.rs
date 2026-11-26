// The code below is a stub. Just enough to satisfy the compiler.
// In order to pass the tests you can add-to or change any of this code.

#[derive(PartialEq, Debug)]
pub enum Direction {
    North,
    East,
    South,
    West,
}

pub struct Robot {
    x: i32,
    y: i32,
    d: Direction,
}

impl Robot {
    pub fn new(x: i32, y: i32, d: Direction) -> Self {
        Self { x, y, d }
    }

    pub fn turn_right(self) -> Self {
        use Direction::*;
        Self {
            d: match self.d {
                North => East,
                East => South,
                South => West,
                West => North,
            },
            ..self
        }
    }

    pub fn turn_left(self) -> Self {
        use Direction::*;
        Self {
            d: match self.d {
                North => West,
                West => South,
                South => East,
                East => North,
            },
            ..self
        }
    }

    pub fn advance(self) -> Self {
        use Direction::*;
        let (dx, dy) = match self.d {
            North => (0, 1),
            South => (0, -1),
            East => (1, 0),
            West => (-1, 0),
        };
        Self {
            x: self.x + dx,
            y: self.y + dy,
            ..self
        }
    }

    pub fn instructions(self, instructions: &str) -> Self {
        instructions.chars()
            .fold(self, |robot, chr| {
                match chr {
                    'L' => robot.turn_left(),
                    'R' => robot.turn_right(),
                    'A' => robot.advance(),
                    c => panic!("No such instruction {}", c),
                }
            })
    }

    pub fn position(&self) -> (i32, i32) {
        (self.x, self.y)
    }

    pub fn direction(&self) -> &Direction {
        &self.d
    }
}
