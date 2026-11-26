let reverse_string s =
  String.init (String.length s) (fun i -> s.[String.length s - i - 1])
