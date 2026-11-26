(* open Str

   let acronym (s : string) : string = (* Split the input string into a list of
   words using a regular expression *) let words = split (regexp "[^a-zA-Z']+")
   s in (* Concatenate the first letter of each word into a single string *) let
   acronym = String.concat "" (List.map (fun w -> String.sub w 0 1) words) in (*
   Convert the resulting string to uppercase *) String.uppercase_ascii
   acronym *)

open Base

let acronym text =
  text |> String.uppercase
  |> String.split_on_chars ~on:[ ' '; '_'; '-' ]
  |> List.filter_map ~f:(function
         | "" -> None
         | s -> Some (String.get s 1 |> Char.to_string))
  |> String.concat
