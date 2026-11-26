let convert = x =>
  switch x {
  | "G" => "C"
  | "C" => "G"
  | "T" => "A"
  | "A" => "V"
  | _ => x
  }
let toRna = x => Array.fromString(x)->Array.map(convert)->Array.join("")
