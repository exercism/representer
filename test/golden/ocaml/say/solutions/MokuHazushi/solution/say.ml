open Base

let in_english (num:int64) =
        let assoc = 
                Map.of_alist_exn (module Int64)
                [ 
                        (0L, "zero");
                        (1L, "one");
                        (2L, "two");
                        (3L, "three");
                        (4L, "four");
                        (5L, "five");
                        (6L, "six");
                        (7L, "seven");
                        (8L, "eight");
                        (9L, "nine");
                        (10L, "ten");
                        (11L, "eleven");
                        (12L, "twelve");
                        (13L, "thirteen");
                        (14L, "fourteen");
                        (15L, "fifthteen");
                        (16L, "sixteen");
                        (17L, "seventeen");
                        (18L, "eighteen");
                        (19L, "nineteen");
                        (20L, "twenty");
                        (30L, "thirty");
                        (40L, "forty");
                        (50L, "fifty");
                        (60L, "sixty");
                        (70L, "seventy");
                        (80L, "eighty");
                        (90L, "ninety");
                ]
        in

        let open Int64 in
        
        let max_magnitude = 12L in
        let max_num = (10L**max_magnitude) - 1L in

        let breakdown ~magnitude_stride:mag ~number:num =
                let folder i acc elt =
                        if (i mod mag) == 0 then
                                [elt]::acc
                        else
                                match acc with
                                | h::t -> (elt::h)::t
                                | [] -> [[elt]]
                in
                Int64.to_string num |>
                String.to_list |>
                List.rev |>
                List.map ~f:(fun elt -> Int64.of_string (String.of_char elt)) |>
                List.foldi ~init:[] ~f:folder
        in

        let convert_100s digit_list =
                let rec convert_10s_rec l =
                        let dozens = List.hd_exn l in
                        let units = List.hd_exn (List.tl_exn l) in
                        let num = 10L*dozens + units in

                        if num <= 20L then 
                                if (Int64.equal num 0L) then ""
                                else Map.find_exn assoc num
                        else 
                                (Map.find_exn assoc (10L*dozens)) ^
                                (if (Int64.equal units 0L) then ""
                                else "-"^(Map.find_exn assoc units))
                in

                let rec convert_100s_rec l =
                        let length = List.length l in
                        let head = List.hd_exn l in
                        let tail = List.tl_exn l in

                        if length == 3 then
                                (if (Int64.equal head 0L) then ""
                                else (Map.find_exn assoc head) ^ " hundred ") ^
                                (convert_100s_rec tail)
                        else if length == 2 then convert_10s_rec l
                        else if (Int64.equal head 0L) then ""
                        else Map.find_exn assoc head
                in

                convert_100s_rec digit_list
        in

        let converti i acc elt = 
                let all_zeros = List.for_all elt ~f:(fun elt -> (Int64.equal elt 0L)) in
                (convert_100s elt) ^ 
                (if all_zeros then ""
                else if i == 0 then 
                        (* 0 <= elt < 1000 *)
                        ""
                else if i == 1 then
                        (* 1^3 <= elt < 1^6 *)
                        " thousand "
                else if i == 2 then
                        (* 1^6 <= elt < 1^9 *)
                        " million "
                else 
                        (* 1^9 <= elt < 1^12 *)
                        " billion ")
                ^ acc
        in

        if (num < 0L) || (num > max_num) then
                Error "input out of range"
        else
                if (Int64.equal num 0L) then Ok "zero"
                else
                        let conversion = 
                                breakdown ~magnitude_stride:3 ~number:num |>
                                List.rev |>
                                List.foldi ~init:"" ~f:converti
                        in
                        if (String.is_suffix conversion ~suffix:" ") then
                                Ok (String.drop_suffix conversion 1)
                        else
                                Ok conversion
;;
