module StringCounter = (Map.Make (String))
let incr_counter value_opt =
    match value_opt with
    | None -> Some 1
    | Some v -> Some (v + 1)
let update_counter counter word = StringCounter.update word incr_counter counter


type word =
    | Number of char list
    | Simple of char list
    | Contraction of (char list * char list)
let contractor = '\''
let list_of_string s = s |> String.to_seq |> List.of_seq
let string_of_list l = l |> List.to_seq |> String.of_seq

let word_rev word = match word with
    | Number s -> Number (List.rev s)
    | Simple s -> Simple (List.rev s)
    | Contraction (left, right) -> Contraction (List.rev left, List.rev right)

let string_of_word word = 
    let formatted = match word with
    | Number s | Simple s -> string_of_list s
    | Contraction (left, right) -> 
        if right <> [] then string_of_list (left @ (contractor::right))
        else string_of_list left
    in String.lowercase_ascii formatted

type parsing_state = 
    | Space
    | Word of word

let digits = list_of_string "01234567989"
let is_digit c = List.mem c digits

let letters = list_of_string "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let is_letter c = List.mem c letters

let rec split_words_acc (acc: word list) (current: parsing_state) (charlist: char list) = 
    match (current, charlist) with
    | (Space, []) -> acc
    | (Word w, []) -> (word_rev w) :: acc
    | (Space, h::t) -> 
        if is_digit h then split_words_acc acc (Word (Number [h])) t
        else if is_letter h then split_words_acc acc (Word (Simple [h])) t
        else split_words_acc acc Space t
    | (Word (Number n as w), h::t) ->
        if is_digit h then split_words_acc acc (Word (Number (h::n))) t
        else let next_acc = (word_rev w)::acc in 
        if is_letter h then split_words_acc next_acc (Word (Simple [h])) t
        else split_words_acc next_acc Space t
    | (Word (Simple s as w), h::t) ->
        if is_letter h then split_words_acc acc (Word (Simple (h::s))) t
        else if h = contractor then split_words_acc acc (Word (Contraction (s, []))) t
        else let next_acc = (word_rev w)::acc in 
        if is_digit h then split_words_acc next_acc (Word (Number [h])) t
        else split_words_acc next_acc Space t
    | (Word (Contraction (l, r) as w), h::t) ->
        if is_letter h then split_words_acc acc (Word (Contraction (l, h::r))) t
        else let next_acc = (word_rev w)::acc in
        if is_digit h then split_words_acc next_acc (Word (Number [h])) t
        else split_words_acc next_acc Space t

let word_count phrase = split_words_acc [] Space (list_of_string phrase)
    |> List.map string_of_word
    |> List.fold_left update_counter StringCounter.empty
    |> StringCounter.to_seq
    |> List.of_seq
    |> let open Base in Map.of_alist_exn (module String)
