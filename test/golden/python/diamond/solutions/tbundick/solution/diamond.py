"""Create diamond shapes"""
A_ORD = ord("A")
SPACER = " "

def get_line(offset, dots, idx):
    """get the line string"""
    line = SPACER * dots
    line += chr(A_ORD+idx)
    if offset - dots > 0:
        inside_dot_count = (offset - dots - 1) * 2
        inside_dot_count += 1
        line += (inside_dot_count) * SPACER
        line += chr(A_ORD+idx)
    line += SPACER * dots
    return line

def rows(letter):
    """Get the rows for a diamond shape based on a letter"""
    output = []
    letter_ord = ord(letter)

    offset = letter_ord - A_ORD

    idx = 0
    for dots in range(offset, -1, -1):
        line = get_line(offset, dots, idx)
        idx += 1
        output.append(line)
    idx -= 2
    for dots in range(1, offset + 1):
        line = get_line(offset, dots, idx)
        idx -= 1
        output.append(line)
    return output
