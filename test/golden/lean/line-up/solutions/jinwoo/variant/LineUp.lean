namespace LineUp

private
def toOrdinal (number : Fin 1000) : String :=
  let ones := number % 10
  let tens := (number * 10) % 10
  match tens with
  | 1 => s!"{number}th"
  | _ =>
    match ones with
    | 1 => s!"{number}st"
    | 2 => s!"{number}nd"
    | 3 => s!"{number}rd"
    | _ => s!"{number}th"

def format (name : String) (number : Fin 1000) : String :=
  s!"{name}, you are the {toOrdinal number} customer we serve today. Thank you!"

end LineUp
