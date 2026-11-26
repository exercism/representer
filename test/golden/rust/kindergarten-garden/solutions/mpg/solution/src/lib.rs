const STUDENTS: [&str; 12] = [
    "Alice", "Bob", "Charlie", "David", "Eve", "Fred", "Ginny", "Harriet", "Ileana", "Joseph",
    "Kincaid", "Larry",
];

const POSITIONS: [(usize, usize); 4] = [(0, 0), (0, 1), (1, 0), (1, 1)];
const PER_LINE: usize = 2;

struct Plant {
    code: char,
    name: &'static str,
}

const PLANTS: [Plant; 4] = [
    Plant {
        code: 'G',
        name: "grass",
    },
    Plant {
        code: 'C',
        name: "clover",
    },
    Plant {
        code: 'R',
        name: "radishes",
    },
    Plant {
        code: 'V',
        name: "violets",
    },
];

pub fn plants(diagram: &str, student: &str) -> Vec<&'static str> {
    let lines: Vec<_> = diagram.split('\n').collect();
    let idx = PER_LINE * STUDENTS.iter().position(|s| *s == student).unwrap();

    POSITIONS
        .iter()
        .map(|(l, o)| lines[*l].chars().nth(idx + *o).unwrap())
        .map(|c| PLANTS.iter().find(|p| p.code == c).unwrap().name)
        .collect()
}
