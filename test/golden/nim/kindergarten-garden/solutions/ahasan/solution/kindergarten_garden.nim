import tables, strutils

type Plant* = enum Clover, Grass, Radishes, Violets

var plantsMap = newTable[char, Plant](4)
for plant in Plant: plantsMap[($plant)[0]] = plant

const childs = ["Alice", "Bob", "Charlie", "David",
                "Eve", "Fred", "Ginny", "Harriet",
                "Ileana", "Joseph", "Kincaid", "Larry"]

proc plants*(garden, child: string): seq[Plant] =
  let childIdx = childs.find(child)
  for row in garden.splitLines:
    result.add(plantsMap[row[childIdx * 2]])
    result.add(plantsMap[row[childIdx * 2 + 1]])
