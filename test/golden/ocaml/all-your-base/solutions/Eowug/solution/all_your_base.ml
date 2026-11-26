open Base

type base = int

let to_decimal base digits = let len = List.length digits - 1 in digits |> List.foldi ~init:(Ok 0) ~f:(fun i acc digit -> if digit >= 0 && digit < base then match acc with Ok acc -> Ok(acc + digit * Int.pow base (len - i)) | Error digit -> Error digit else Error digit)

let to_base base num = if num <> 0 then let rec loop acc num = match num with 0 -> acc | _ -> loop (Int.rem num base :: acc) (num / base) in loop [] num else [0]

let convert_bases ~from ~digits ~target = if from > 1 && target > 1 then match to_decimal from digits with Ok num -> Some(to_base target num) | _ -> None else None