def validate(input_grid):
    if len(input_grid) % 4 != 0:
        raise ValueError("Number of input lines is not a multiple of four")
    if not all(len(line) % 3 == 0 and len(line) == len(input_grid[0]) for line in input_grid):
        raise ValueError("Number of input columns is not a multiple of three")

def cut_lines(input_grid):
    lines = []
    for i in range(0,len(input_grid) // 4):
        lines.append(input_grid[i*4:i*4+4])
    return lines

def cut_digits(input_grid):
    digits = []
    for i in range(0,len(input_grid[0]) // 3):
        digits.append([
            input_grid[0][i * 3 : i * 3 + 3],
            input_grid[1][i * 3 : i * 3 + 3],
            input_grid[2][i * 3 : i * 3 + 3],
            input_grid[3][i * 3 : i * 3 + 3]
        ])
    return digits

def recognize_digit(input_grid):
    if input_grid == [" _ ", "| |", "|_|", "   "]:
        return "0"
    if input_grid == ["   ", "  |", "  |", "   "]:
        return "1"
    if input_grid == [" _ ", " _|", "|_ ", "   "]:
        return "2"
    if input_grid == [" _ ", " _|", " _|", "   "]:
        return "3"
    if input_grid == ["   ", "|_|", "  |", "   "]:
        return "4"
    if input_grid == [" _ ", "|_ ", " _|", "   "]:
        return "5"
    if input_grid == [" _ ", "|_ ", "|_|", "   "]:
        return "6"
    if input_grid == [" _ ", "  |", "  |", "   "]:
        return "7"
    if input_grid == [" _ ", "|_|", "|_|", "   "]:
        return "8"
    if input_grid == [" _ ", "|_|", " _|", "   "]:
        return "9"
    return "?"

def convert(input_grid):
    validate(input_grid)
    recognized_lines = []
    for line in cut_lines(input_grid):
        recognized_lines.append("".join([recognize_digit(digit) for digit in cut_digits(line)]))
    return ",".join(recognized_lines)