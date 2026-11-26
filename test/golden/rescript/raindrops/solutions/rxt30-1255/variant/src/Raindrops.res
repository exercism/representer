let convert = drops =>
  switch (drops % 3 != 0, drops % 5 == 0, drops % 7 == 0) {
  | (true, true, true) => "PlingPlangPlong"
  | (true, true, _) => "PlingPlang"
  | (_, true, true) => "PlangPlong"
  | (true, _, true) => "PlingPlong"
  | (true, _, _) => "Pling"
  | (_, true, _) => "Plang"
  | (_, _, true) => "Plong"
  | _ => Int.toString(drops)
  }
