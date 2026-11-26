type position = (i32, i32)

type direction = #north | #east | #south | #west

type state = (position, direction)

-- Helper function to turn right
local def turn_right (d: direction): direction =
  match d
    case #north -> #east
    case #east -> #south
    case #south -> #west
    case #west -> #north

-- Helper function to turn left
local def turn_left (d: direction): direction =
  match d
    case #north -> #west
    case #east -> #north
    case #south -> #east
    case #west -> #south

-- Helper function to advance in the current direction
local def advance (pos: position) (d: direction): position =
  match d
    case #north -> (pos.0, pos.1 + 1)
    case #east -> (pos.0 + 1, pos.1)
    case #south -> (pos.0, pos.1 - 1)
    case #west -> (pos.0 - 1, pos.1)

-- Process a single instruction
local def process_instruction (s: state) (instr: u8): state =
  if instr == 82 then  -- 'R'
    (s.0, turn_right s.1)
  else if instr == 76 then  -- 'L'
    (s.0, turn_left s.1)
  else if instr == 65 then  -- 'A'
    (advance s.0 s.1, s.1)
  else
    s  -- Unknown instruction, no change

def move (start: state) (instructions: []u8): state =
  loop current_state = start for i < length instructions do
    process_instruction current_state instructions[i]
        