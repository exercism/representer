import strformat,sequtils,algorithm

type
  Student* = object
    name*: string
    grade*: int

  School* = object
    students*: seq[Student]
    grades: set[1..12]

proc addStudent*(school: var School, name: string, grade: int) =
  ## Adds a student with `name` and `grade` to the `school`.
  ##
  ## Raises a `ValueError` if `school` already contains a student named `name`.

  if school.students.filterIt(it.name == name).len > 0 : 
    raise newException(ValueError,fmt"Student {name} already enrolled")
  school.students.add Student(name: name,grade: grade)
  school.grades.incl grade
  # discard

proc grade*(school: School, grade: int): seq[string] =
  ## Returns the names of the students in the given `school` and `grade`, in
  ## alphabetical order.
  
  return school.students.filterIt(it.grade == grade).sortedByIt(it.name).mapIt(it.name)

proc roster*(school: School): seq[string] =
  ## Returns the names of every student in the `school`, sorted by grade then name.
  # return school.
  
  for n in school.grades: result.add school.grade(n)
