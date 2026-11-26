fun isBalanced s =
    let
        fun is_bracket bracket = 
            case bracket of
                #"(" => true
                | #"[" => true
                | #"{" => true
                | #")" => true
                | #"]" => true
                | #"}" => true
                | _ => false

        fun is_open bracket =
            case bracket of
                #"(" => true
                | #"[" => true
                | #"{" => true
                | _ => false

        fun is_matching_bracket bracket_open bracket_closed =
            case (bracket_open, bracket_closed) of
                (#"(",#")") => true
                | (#"[",#"]") => true
                | (#"{",#"}") => true
                | _ => false

        fun isBalancedAcc s seen =
            case (s, seen) of
                ([], []) => true
                | (x::xs, []) => if is_open x then isBalancedAcc xs (x::[]) else false
                | ([], (_::_)) => false
                | (x::xs, y::ys) => if is_open x 
                                    then isBalancedAcc xs (x::y::ys)
                                    else (if is_matching_bracket y x
                                             then isBalancedAcc xs ys
                                             else false)
    in
        isBalancedAcc (List.filter is_bracket (String.explode s)) []
    end
