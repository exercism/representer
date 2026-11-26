include std/sequence.e
include std/search.e

constant MAPPINGS = {
  {'G', "grass"},
  {'C', "clover"},
  {'R', "radishes"},
  {'V', "violets"}
}

public function plants(sequence garden, sequence student)
  garden = split(garden, "\n", 1, 2)
  integer group_num = student[1] - 'A'
  return {
    map(garden[1][1 + group_num * 2]),
    map(garden[1][1 + group_num * 2 + 1]),
    map(garden[2][1 + group_num * 2]),
    map(garden[2][1 + group_num * 2 + 1])
  }
end function

function map(integer c)
  return vlookup(c, MAPPINGS, 1, 2)
end function
