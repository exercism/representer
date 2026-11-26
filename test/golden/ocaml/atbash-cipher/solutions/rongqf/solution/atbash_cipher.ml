open Base

let chars = ['a';'b';'c';'d';'e';'f';'g';'h';'i';'j';'k';'l';'m';'n';'o';'p';'q';'r';'s';'t';'u';'v';'w';'x';'y';'z';]

let reps = List.map2_exn chars (List.rev chars) ~f:(fun a b->(a,b))
|> List.fold_left ~init:(Map.empty (module Char)) ~f:(fun a (k,v)-> Map.add_exn ~key:k ~data:v a)

let rec split n s = 
    if String.length s <= n then [s]
    else (String.prefix s n)::(split n (String.drop_prefix s n))
    
let fltchr c = 
    match c with
    |'a'..'z'->true
    |'0'..'9'->true
    |_->false
    
let repc_chr c = 
    match Map.find reps c with
    |None->c
    |Some v->v
    
let encode ?block_size s =
    s
    |> String.lowercase
    |> String.filter ~f:fltchr
    |> String.map ~f:repc_chr
    |> split (match block_size with |None->5 |Some v->v)
    |> String.concat ~sep:" "

let decode s =
    encode s
    |> String.substr_replace_all ~pattern:" "  ~with_:""

