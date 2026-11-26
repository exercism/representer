import tables
import strutils

proc transform*(input: Table[int, seq[char]]): Table[char, int] =
    for k, v in input:
       for chr in v:
         result[chr.toLowerAscii] = k
