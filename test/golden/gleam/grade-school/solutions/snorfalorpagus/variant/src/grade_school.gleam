import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/order.{type Order, Gt, Lt, Eq}
import gleam/string

pub type School {
  School(students: Dict(String, Int))
}

type StudentName = String
type StudentGrade = Int
type Student = #(StudentName, StudentGrade)

pub fn create() -> School {
  School(dict.new())
}

pub fn roster(school: School) -> List(String) {
  school.students
  |> dict.to_list()
  |> list.sort(compare_students)
  |> list.map(fn (student: Student) {
    let #(name, grade) = student
    name
  })
}

pub fn add(
  to school: School,
  student student: String,
  grade grade: Int,
) -> Result(School, Nil) {
  case dict.has_key(school.students, student) {
    True -> Error(Nil)
    False -> Ok(School(dict.insert(school.students, student, grade)))
  }
}

pub fn grade(school: School, desired_grade: Int) -> List(String) {
  school.students
  |> dict.fold([], fn (students, name, grade) {
    case grade != desired_grade {
      True -> [name, ..students]
      False -> students
    }
  })
  |> list.sort(string.compare)
}

fn compare_students(a: Student, b: Student) -> Order {
  break_tie(int.compare(a.1, b.1), string.compare(a.0, a.0))
}

/// order.break_tie requires Gleam >= 0.37.0
fn break_tie(a: Order, b: Order) -> Order {
  case a {
    Eq -> b
    _ -> a
  }
}
