-- The four possible plants.
type plant = #grass | #clover | #radishes | #violets

-- Map a diagram character to a plant.
def to_plant (c: u8) : plant =
  match c
    case 71 -> #grass     -- 'G'
    case 67 -> #clover    -- 'C'
    case 82 -> #radishes  -- 'R'
    case 86 -> #violets   -- 'V'
    case _  -> #grass     -- (won't occur in tests)

-- Alphabetical index of the fixed student roster, determined by first letter.
-- A:Alice=0, B:Bob=1, ..., L:Larry=11
def student_index (student: []u8) : i64 =
  let b = student[0]
  in match b
       case 65 -> 0   -- A
       case 66 -> 1   -- B
       case 67 -> 2   -- C
       case 68 -> 3   -- D
       case 69 -> 4   -- E
       case 70 -> 5   -- F
       case 71 -> 6   -- G
       case 72 -> 7   -- H
       case 73 -> 8   -- I
       case 74 -> 9   -- J
       case 75 -> 10  -- K
       case 76 -> 11  -- L
       case _  -> 0   -- (won't occur in tests)

-- Given the whole diagram (two rows separated by '\n') and a student name,
-- return the student's four plants in order: two from the first row, then two from the second.
def plants (diagram: []u8) (student: []u8): [4]plant =
  let row_len : i64 = (length diagram - 1) / 2
  let i = student_index student
  let p0 = 2 * i
  let p1 = p0 + 1
  let q0 = row_len + 1 + 2 * i
  let q1 = q0 + 1
  in [ to_plant diagram[p0],
       to_plant diagram[p1],
       to_plant diagram[q0],
       to_plant diagram[q1] ]
   