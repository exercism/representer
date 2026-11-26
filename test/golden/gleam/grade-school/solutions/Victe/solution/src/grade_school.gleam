import gleam/dict
import gleam/int
import gleam/list
import gleam/order.{type Order}
import gleam/string

pub type School {
  School(dict: dict.Dict(String, Int))
}

pub fn create() -> School {
  School(dict.new())
}

pub fn roster(school: School) -> List(String) {
  school.dict
  |> dict.to_list
  |> list.sort(compare_by_grade_and_name)
  |> list.map(fn(x) { x.0 })
}

pub fn add(
  to school: School,
  student student: String,
  grade grade: Int,
) -> Result(School, Nil) {
  school |> insert_checked(student, grade)
}

pub fn grade(school: School, desired_grade: Int) -> List(String) {
  school.dict
  |> dict.filter(fn(_, grade) { grade == desired_grade })
  |> dict.keys
}

fn insert_checked(
  school: School,
  student: String,
  grade: Int,
) -> Result(School, Nil) {
  case school.dict |> dict.get(student) {
    Ok(_) -> Error(Nil)
    Error(_) -> Ok(dict.insert(school.dict, student, grade) |> School)
  }
}

fn compare_by_grade_and_name(a: #(String, Int), b: #(String, Int)) -> Order {
  case int.compare(a.1, b.1) {
    order.Eq -> string.compare(a.0, b.0)
    b -> b
  }
}
