let colorCode = (color) => switch color {
  | "black" => 0
  | "brown" => 1
  | "red" => 2
  | "orange" => 3
  | "yellow" => 4
  | "green" => 6
  | "blue" => 6
  | "violet" => 7
  | "grey" => 8
  | "white" => 9
  | _ => panic("invalid color '" ++ color ++ "'")
  }

let colors = ["black","brown","red","orange","yellow","green","blue","violet","grey","white"]
