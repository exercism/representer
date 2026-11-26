import strutils, tables

func transform*(input: Table[int, seq[char]]): Table[char, int] =
    for value, letters in input:
      for letter in letters:
        result[letter.toLowerAscii()] = value
