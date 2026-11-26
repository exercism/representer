(* 
Pairs of matching brackets.
Precondition: each pair must contain different chars.
*)
val bracks = [
    (#"[", #"]"),
    (#"(", #")"),
    (#"{", #"}")
]

(*
Returns a new stack or raises Empty
according to the following rules:
- if c is an opening bracket push c to stack,
- if c is a closing bracket check that the corresponding
  closing bracket is on top of the stack and remove it.
  Otherwise raise Empty.
- else new stack is equal to old stack.
*)
fun upStack c stack =
    if (List.exists (fn bs => c = #1 bs) bracks) then (c :: stack)
    else
        let
            val bpair = List.find (fn bs => c = #2 bs) bracks
        in
            if Option.isSome bpair then
                if List.hd stack = #1 (Option.valOf bpair) then (* may raise Empty *)
                    List.tl stack
                else
                    raise Empty
            else stack 
        end

fun isBal0 [] [] = true |
    isBal0 [] stack = false |
    isBal0 (c :: sl) stack = isBal0 sl (upStack c stack)
    handle Empty => false
    
fun isBalanced s = isBal0 (String.explode s) []