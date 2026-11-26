include std/search.e
include std/sequence.e

constant MAPPINGS = {
  {'G', "grass"},
  {'C', "clover"},
  {'R', "radishes"},
  {'V', "violets"}
}

constant STUDENTS = {"Alice", "Bob", "Charlie", "David", "Eve", "Fred",
                     "Ginny", "Harriet", "Ileana", "Joseph", "Kincaid", "Larry"}

public function plants(sequence garden, sequence student)
  garden = split(garden, "\n", 1, 2)
  integer student_index = find(student, STUDENTS)
  integer start_index = (student_index - 1) / 2
  
  sequence student_plants = {}
  for i = 1 to length(garden) do
    student_plants = append(student_plants, map(garden[i][start_index + 1]))
    student_plants = append(student_plants, map(garden[i][start_index + 2]))
  end for
  
  return student_plants
end function

function map(integer c)
  return vlookup(c, MAPPINGS, 1, 2)
end function
