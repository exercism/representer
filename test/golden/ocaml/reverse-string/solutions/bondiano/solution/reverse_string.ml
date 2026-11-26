let reverse_string str =
  String.fold_left (fun acc c -> (String.make 1 c) ^ acc) "" str
