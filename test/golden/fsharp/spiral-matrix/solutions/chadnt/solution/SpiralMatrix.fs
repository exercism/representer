module SpiralMatrix

let rotate = List.transpose >> List.map List.rev

let rec matrixSpiral i j s =
    match i with
    | 0 -> [[]]
    | _ -> [s .. s+j-1] 
           :: (matrixSpiral j (i-1) (s+j) |> rotate)

let spiralMatrix = function
    | 0 -> []
    | n -> matrixSpiral n n 1