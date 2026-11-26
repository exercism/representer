def nums: i32 -> []i32 = \x -> 2...x/2

def square_root: i32 -> i32 = \x -> match x case 0 -> 0 case 1 -> 1 case _ -> nums x |> map (\n -> if n * n == x then n else 0) |> i32.sum
