from strutils import toLowerAscii
import tables

proc transform*(input: Table[int, seq[char]]): Table[char, int] =
    for value, letters in input.pairs:
        for letter in letters:
            result[letter.toLowerAscii] = value