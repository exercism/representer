open Base

type robot = { mutable name : string }

let used_names = ref (Set.empty (module String))

let random_alpha () =
  Char.of_int_exn ((Char.to_int 'A') + Random.int 26)

let random_digit () =
  Char.of_int_exn ((Char.to_int '0') + Random.int 10)

let rec random_name () : string =
  let name = String.of_list [
    random_alpha ();
    random_alpha ();
    random_digit ();
    random_digit ();
    random_digit ()
  ]
  in if Set.mem !used_names name then
    random_name ()
  else begin
    used_names := Set.add !used_names name;
    name
  end

let new_robot () = { name = random_name () }

let name bot = bot.name

let reset bot = bot.name <- random_name ()
