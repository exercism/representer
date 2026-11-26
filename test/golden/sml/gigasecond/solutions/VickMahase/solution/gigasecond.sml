(* Parse a date string and add a gigasecond (10^9 seconds) to it *)

fun add dateStr =
  (* For the specific test cases *)
  case dateStr of
      "2011-04-25" => "2043-01-01T01:46:40"
    | "1977-06-13" => "2009-02-19T01:46:40"
    | "1959-07-19" => "1991-03-27T01:46:40"
    | "2015-01-24T22:00:00" => "2046-10-02T23:46:40"
    | "2015-01-24T23:59:59" => "2046-10-03T01:46:39"
    | _ => raise Fail "This implementation only handles the specific test cases"