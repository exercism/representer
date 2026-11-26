let reverse_string str =
  String.fold_left (fun acc c -> (String.make 2 c) ^ acc) "" str
