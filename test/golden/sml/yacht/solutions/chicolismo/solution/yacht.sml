local open List
in
  datatype category
    = Ones | Twos | Threes | Fours | Fives | Sixes | FullHouse
    | FourOfAKind | LittleStraight | BigStraight | Choice | Yacht

  fun score ([]: int list, _: category) : int = 0
    | score (dice, cat) =
        case cat of
          Ones   => sum (filter (equal 1) dice)
        | Twos   => sum (filter (equal 2) dice)
        | Threes => sum (filter (equal 3) dice)
        | Fours  => sum (filter (equal 4) dice)
        | Fives  => sum (filter (equal 5) dice)
        | Sixes  => sum (filter (equal 6) dice)
        | FullHouse =>
            (case group dice of
               [[_, _, _], [_, _]] => sum dice
             | [[_, _], [_, _, _]] => sum dice
             | _ => 0)
        | FourOfAKind =>
            (case group dice of
               [values as [_, _, _, _, _]]   => sum (tl values)
             | [values as [_, _, _, _], [_]] => sum values
             | [[_], values as [_, _, _, _]] => sum values
             | _ => 0)
        | LittleStraight => if (qsort dice) = [1, 2, 3, 4, 5] then 30 else 0
        | BigStraight    => if (qsort dice) = [2, 3, 4, 5, 6] then 30 else 0
        | Choice         => sum dice
        | Yacht          => if all (equal (hd dice)) dice then 50 else 0

  (* A dumb sorting function.
   * Apparently this function is too pedestrian to be included by default.
   *)
  and qsort [] = []
    | qsort (x :: xs) =
        let
          val greater = filter (fn n => n >= x) xs
          val smaller = filter (fn n => n < x) xs
        in
          (qsort smaller) @ (x :: qsort greater)
        end

  and sum xs =
    foldl op+ 0 xs

  and equal a b = a = b

  and group (xs: int list) : int list list = group' xs []

  and group' (xs: int list) (g: int list list) : int list list =
    case xs of
      [] => g
    | x :: ys => group' ys (addToGroup x g)

  and addToGroup x [] = [[x]]
    | addToGroup x ((y :: xs) :: zs) =
        if x = y then ((x :: y :: xs) :: zs) else (y :: xs) :: (addToGroup x zs)
    (* shouldn't happen *)
    | addToGroup x ([] :: zs) = addToGroup x zs
end
