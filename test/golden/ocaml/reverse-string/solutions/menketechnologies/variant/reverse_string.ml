let reverse_string = String.fold_left (fun acc c -> (String.make 2 c) ^ acc) ""
