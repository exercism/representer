import sequtils
import std/algorithm

type
  Student* = object
    name*: string
    grade*: int

  School* = object
    students*: seq[Student]

proc cmpStudents(x, y: Student): int =
  let result = cmp(x.grade, y.grade)

  if result == 0:
    return cmp(x.name, y.name)

  result

proc roster*(school: School): seq[string] =
  ## Returns the names of every student in the `school`, sorted by grade then name.
  school.students.sortedByIt((it.grade, it.name)).mapIt(it.name)

proc addStudent*(school: var School, name: string, grade: int) =
  ## Adds a student with `name` and `grade` to the `school`.
  ##
  ## Raises a `ValueError` if `school` already contains a student named `name`.
  if school.students.anyIt(it.name == name):
    raise newException(ValueError, "the student already exists")

  school.students.add(Student(name: name, grade: grade))

proc grade*(school: School, grade: int): seq[string] =
  ## Returns the names of the students in the given `school` and `grade`, in
  ## alphabetical order.
  school.students.filterIt(it.grade == grade).sortedByIt(it.name).mapIt(it.name)
