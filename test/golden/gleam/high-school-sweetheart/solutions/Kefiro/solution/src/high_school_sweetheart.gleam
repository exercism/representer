import gleam/string
import gleam/result
import gleam/list

pub fn first_letter(name: String) {
  name
  |> string.trim()
  |> string.first()
  |> result.unwrap("")
}

pub fn initial(name: String) {
  name
  |> first_letter()
  |> string.uppercase()
  |> string.append(".")
}

pub fn initials(full_name: String) {
  full_name
  |> string.trim()
  |> string.split(" ")
  |> list.map(initial)
  |> string.join(" ")
}

pub fn pair(full_name1: String, full_name2: String) {
"
     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     X. X.  +  X. X.     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
" 
  |> string.replace(
      "X. X.  +",
      full_name1
      |> initials()
      |> string.append("  +"))    
  |> string.replace(
      "X. X.", 
      full_name2
      |> initials())
}
