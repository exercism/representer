namespace LineUp

def format (name : String) (number : Fin 1001) : String :=
  let ordNum := s!"{number}"
  let ordNum := if ordNum.endsWith "1" && !ordNum.endsWith "11" then ordNum ++ "st"
    else if ordNum.endsWith "2" && !ordNum.endsWith "12" then ordNum ++ "nd"
    else if ordNum.endsWith "3" && !ordNum.endsWith "13" then ordNum ++ "rd" else ordNum ++ "th"
  s!"{name}, you are the {ordNum} customer we serve today. Thank you!"

end LineUp
