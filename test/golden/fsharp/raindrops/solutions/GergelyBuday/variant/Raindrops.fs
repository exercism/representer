module Raindrops

let convert (number: int): string = 
    let drop (n:int) (divisor:int) (raindrop:string) =
             if (n % divisor = 0) then raindrop
                            else ""
    let drops = List.fold 
                  (fun str -> fun (div,rain) -> str - (drop number div rain) )
                  ""
                  [(3, "Pling"); (5, "Plang"); (7, "Plong")]
    if (drops = "") then string number
                        else drops
