type base = int

let rec get_powers num l = 
  match num with
  | 0 -> l
  |_-> get_powers (num - 1) (l @ [(num - 1)])

let rec sum l=
  match l with
    []->0
  |h::t-> h + (sum t)

let explode s = List.init (String.length s) (String.get s)
let collapse l = int_of_string (String.concat "" (List.map string_of_int l))
let rec check_list l from = match l with 
  | [] -> true
  | hd::tl -> if (hd < 0 || hd >= from) then false else check_list tl from

let remove_last_char s = let str_length = String.length s in String.sub s 0 (str_length - 1)

let int_to_list d =
  let rec dig acc d =
    if d < 10 then d::acc
    else dig ((d mod 10)::acc) (d/10) in
  dig [] d

let to_decimal ~from ~digits =
  let digits_length = List.length digits in
  let powers = get_powers digits_length [] in 
  let combined = List.combine digits powers in
  let calculate (digit, power) = int_of_float (float digit *. float from ** float power) in
  int_to_list (sum (List.map calculate combined))

let rec from_decimal ~target ~digit result = 
  let lst = (digit mod target) :: result in
  let result = (digit / target) in
  match result with
  | 0 -> lst
  | _ -> from_decimal ~target:target ~digit:result lst

let convert_bases ~from ~digits ~target =
  if check_list digits from then 
    match from, target with
    |_, _ when from < 2-> None
    |_,_ when target < 2 -> None
    | _, 10 -> Some (to_decimal ~from:from ~digits:digits)
    |10, _ -> Some (from_decimal ~target:target ~digit:(collapse digits) [])
    |_, _ -> Some (from_decimal ~digit:(collapse (to_decimal ~from:from ~digits:digits)) ~target:target [])
  else None
