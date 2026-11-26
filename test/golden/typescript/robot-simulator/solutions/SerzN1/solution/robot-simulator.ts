export class InvalidInputError extends Error {
  constructor(message: string = 'Invalid Input') {
    super(message)
  }
}

type Direction = typeof directions[number]
type Coordinates = [number, number]
type Command = (x: number, y: number, d: Direction) => [number, number, Direction]

const directions = ['north', 'east', 'south', 'west'] as const
const commandByInstruction: Record<string, Command> = {
  L: (x: number, y: number, d: Direction) => 
    [x, y, directions[(directions.indexOf(d) - 1 + 4) % directions.length]],
  R: (x: number, y: number, d: Direction) => 
    [x, y, directions[(directions.indexOf(d) + 1) % directions.length]],
  A: (x: number, y: number, d: Direction) => 
    [x + movementsByDirection[d][0], y + movementsByDirection[d][1], d]
}
const movementsByDirection: Record<Direction, Coordinates> = {
  'north': [0, 1],
  'south': [0, -1],
  'west': [-1, 0],
  'east': [1, 0],
}

export class Robot {
  private x: number = 0
  private y: number = 0
  private d: Direction = directions[0]
  
  get bearing(): Direction {
    return this.d
  }
  get coordinates(): Coordinates {
    return [this.x, this.y]
  }
  place({x, y, direction}: { x: number; y: number; direction: Direction }) {
    if (!directions.includes(direction)) throw new InvalidInputError()

    this.x = x
    this.y = y
    this.d = direction
  }
  evaluate(instructions: string) {
    for (let i of instructions) {
      if (!(i in commandByInstruction)) throw new InvalidInputError()

      const command: Command = commandByInstruction[i];
      [this.x, this.y, this.d] = command(this.x, this.y, this.d)
    }
  }
}
