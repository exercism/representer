from strutils import splitLines
import tables

type
  Plant* = enum
    Clover, Grass, Radishes, Violets

var abbrevs = newTable[char, Plant]()
for plant in Plant:
  let initial = ($plant)[0]
  abbrevs[initial] = plant

const students = @["Alice", "Bob", "Charlie", "David",
     "Eve", "Fred", "Ginny", "Harriet",
     "Ileana", "Joseph", "Kincaid", "Larry"]

proc plants*(garden: string, student: string): seq[Plant] =
  let
    index = students.find(student) * 2
    rows = splitLines(garden)
    row1 = rows[0]
    row2 = rows[1]
    plants = @[row1[index], row1[index+1],
               row2[index], row2[index+1]]
  for plant in plants:
    result.add(abbrevs[plant])
