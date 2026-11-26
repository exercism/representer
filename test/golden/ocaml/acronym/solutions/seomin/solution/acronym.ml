open Base

let acronym s =
    let not_punct c =
      Char.('A' <= c && c <= 'Z' || 'a' <= c && c <= 'z' || c = ' ' || c = '-') in
    let replace_punctuation s = 
      String.to_list s |> List.filter ~f:not_punct |> String.of_list in
    s |> replace_punctuation
      |> String.split_on_chars ~on:[' '; '-']
      |> List.filter ~f:(fun s' -> String.length s' > 0)
      |> List.map ~f:(fun s' -> String.get s' 0 |> Char.uppercase)
      |> String.of_list