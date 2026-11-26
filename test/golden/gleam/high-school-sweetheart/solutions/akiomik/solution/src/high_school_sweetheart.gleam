import gleam/string as s

pub fn first_letter(name: String) {
  case name |> s.trim |> s.first {
    Ok(fst)  -> fst
    Error(_) -> ""
  }
}

pub fn initial(name: String) {
  let ini = name |> first_letter |> s.uppercase
  ini <> "."
}

pub fn initials(full_name: String) {
  case s.split(full_name, on: " ") {
    [a, b] -> initial(a) <> " " <> initial(b)
    _      -> ""
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
