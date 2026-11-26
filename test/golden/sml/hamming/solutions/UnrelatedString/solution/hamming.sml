fun distance (strand1: string, strand2: string): int option =
    let fun d (HA::A) (HB::B) N = d A B (N + (
            if HA = HB (* Why can't I pattern match the heads together? *)
            then 0
            else 1
            ))
          | d [] [] N = N
          | d _ _ _ = ~1 (* either A or B is shorter *)
    in
        case d (String.explode strand1) (String.explode strand2) 0 of
          ~1 => NONE
        | X => SOME X
    end
