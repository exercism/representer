open Base

type rle_block_t = { symbol : char; count : int }

let rec encode_blocks ~blocks charlist =
  match (blocks, charlist) with
  | _, [] ->
      blocks |> List.rev
      |> List.map ~f:(fun { symbol; count } ->
             let suffix = String.make 1 symbol in
             if count > 1 then Int.to_string count ^ suffix else suffix)
      |> String.concat
  | [], h :: t -> encode_blocks ~blocks:[ { symbol = h; count = 1 } ] t
  | { symbol; count } :: blkt, h :: t when Char.( = ) symbol h ->
      encode_blocks ~blocks:({ symbol; count = count + 1 } :: blkt) t
  | _, h :: t -> encode_blocks ~blocks:({ symbol = h; count = 1 } :: blocks) t

let rec decode_blocks current_count acc charlist =
  let update_counter cnt digit = (10 * cnt) + digit in
  let helper c t =
    match (current_count, Char.is_digit c) with
    | None, false -> decode_blocks None (acc ^ String.make 1 c) t
    | None, true ->
        decode_blocks (String.make 1 c |> Int.of_string |> Option.some) acc t
    | Some n, false -> decode_blocks None (acc ^ String.make n c) t
    | Some n, true ->
        decode_blocks
          (String.make 1 c |> Int.of_string |> update_counter n |> Option.some)
          acc t
  in
  match charlist with [] -> acc | c :: t -> helper c t

let encode input = input |> String.to_list |> encode_blocks ~blocks:[]
let decode input = input |> String.to_list |> decode_blocks None ""
