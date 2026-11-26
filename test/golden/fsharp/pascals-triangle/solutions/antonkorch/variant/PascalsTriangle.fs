module PascalsTriangle

let rows numberOfRows : int list list = 
    let rec aux i prev acc =
        if i = numberOfRows then acc
        else
            let cur = [
                for indx, v in prev |> List.indexed do  
                    if indx = 0 then yield 1
                    else yield prev.[indx] + prev.[indx+1] 
            ]            
            let cur = cur @ [1]
            aux (i+1) cur (cur :: acc)

    aux 0 [] []
    |> List.rev