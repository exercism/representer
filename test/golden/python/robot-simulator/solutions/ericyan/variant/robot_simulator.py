# Globals for the directions
# Change the values as you see fit
EAST = 0
NORTH = 1
WEST = 2
SOUTH = 3


class Robot:
    OPS = (
        {"L": NORTH, "R": SOUTH, "A": lambda x, y: (x + 1, y)},
        {"L": WEST, "R": EAST, "A": lambda x, y: (x, y + 1)},
        {"L": SOUTH, "R": NORTH, "A": lambda x, y: (x - 1, y)},
        {"L": EAST, "R": WEST, "A": lambda x, y: (x, y - 1)},
    )

    def __init__(self, direction=NORTH, x_pos=0, y_pos=0):
        self.coordinates = (x_pos, y_pos)
        self.direction = direction

    def move(self, instructions):
        for instruction in instructions:
            op = self.OPS[self.direction]

            if instruction in ("R", "L"):
                self.direction = op[instruction]

            if instruction != "A":
                self.coordinates = op[instruction](self.coordinates[0], self.coordinates[1])
