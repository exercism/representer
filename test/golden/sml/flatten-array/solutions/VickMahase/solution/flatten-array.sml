(* Rose tree *)
datatype 'a tree = Empty | Elem of 'a | List of 'a tree list

fun flatten tree =
  let
    (* Recursive helper function to flatten *)
    fun flattenHelper Empty = []
      | flattenHelper (Elem x) = [x]
      | flattenHelper (List xs) = 
          List.foldr (fn (subtree, acc) => 
            case subtree of
              Empty => acc
            | _ => flattenHelper subtree @ acc
          ) [] xs
  in
    flattenHelper tree
  end