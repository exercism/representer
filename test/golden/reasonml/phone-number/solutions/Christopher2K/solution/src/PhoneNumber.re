let is_number = maybe_number => {
    switch (int_of_string(maybe_number)) {
    | _ => true
    | exception Failure(_) => false
    };
}

let extract_numbers_from_string: (string) => string = string_sequence => {
    let char_array =
        string_sequence
            |> Js.String.split("")
            |> Array.to_list;

    Belt.List.reduce(char_array, "", (maybe_number, current_char) =>
        is_number(current_char) ? maybe_number ++ current_char : maybe_number
    );
};

let phoneNumber: string => option(string) = (maybe_phone) => {
    let clean_maybe_phone = extract_numbers_from_string(maybe_phone);

    let regex = [%re "/^(1)?([2-9][0-9]{2}){2}[0-9]{4}$/"];
    let capture_regex = [%re "/([2-9][0-9]{2}){2}[0-9]{4}/"]

    if (Js.Re.test(clean_maybe_phone, regex)) {
        let regex_result = Js.Re.exec(clean_maybe_phone, capture_regex)

        switch (regex_result) {
        | Some(result) => 
            Js.Re.captures(result)
                |> Js.Array.map(a => Js.Nullable.toOption(a))
                |> Array.to_list
                |> List.hd
        | None => None
        };
    } else {
        None
    }
}
