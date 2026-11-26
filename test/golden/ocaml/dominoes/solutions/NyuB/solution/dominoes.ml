type dominoe = (int * int)

let chainable (da: dominoe) (db: dominoe): dominoe option = 
    let (_, ar) = da and (bl, br) = db in
    if ar = bl then Some db
    else if br = ar then Some (br, bl)
    else None

let rec all_chainable_acc 
    (acc: (dominoe * dominoe list) list) (list_save: dominoe list) 
    (to_match: dominoe) (dominoe_list: dominoe list) = 

    let aux d t = 
        match chainable to_match d with
        | None -> acc
        | Some dr -> (dr, (List.rev (list_save)) @ t)::acc
        
    in match dominoe_list with
        | [] -> acc
        | d::t -> all_chainable_acc (aux d t) (d::list_save) to_match t

let all_chainable: 
    dominoe -> dominoe list -> (dominoe * dominoe list) list = 
    all_chainable_acc [] []

let default (dflt: 'v) (opt: 'v option): 'v = match opt with
    | None -> dflt
    | Some v -> v

let rec chain_acc acc last dl = 
    match dl with
    | [] -> Some (List.rev acc)
    | l -> 
        let all = all_chainable last l
        in if all = [] then None
        else let forks = List.map (fun (d, av) -> chain_acc (d::acc) d av) all
        in let ok = List.find_opt (fun i -> i <> None) forks
        in default None ok

let chain_with_starter (d: dominoe) (dl: dominoe list) = chain_acc [d] d dl

let chain (dl: dominoe list): dominoe list option = match dl with
    | [] -> Some dl
    | [(a,b)] -> if a = b then Some dl else None
    | d::t -> chain_with_starter d t
    