import gleam/result
import gleam/string

pub fn first_letter(name: String) {
  name
  |> string.trim
  |> string.first
  |> result.unwrap("")
}

pub fn initial(name: String) {
  name
  |> first_letter
  |> string.uppercase
  <> "."
}

pub fn initials(full_name: String) {
  let initials =
    full_name
    |> string.split(" ")

  case initials {
    [first, second] -> initial(first) <> " " <> initial(second)
    _ -> ""
  }
}

pub fn pair(full_name1: String, full_name2: String) {
  "
     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     " <> initials(full_name1) <> "  +  " <> initials(full_name2) <> "     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
"
}
