module BirdWatcher

let lastWeek: int[] = [| 0; 2; 5; 3; 7; 8; 4 |]

let yesterday(counts: int[]): int = 
    let length = counts |> Array.length
    counts[length - 2]

let total(counts: int[]): int =
  counts |> Array.sum

let dayWithoutBirds(counts: int[]): bool =
  counts |> Array.contains 0

let incrementTodaysCount(counts: int[]): int[] =
 counts |> Array.updateAt 6 (counts[6] + 1)

let unusualWeek(counts: int[]): bool =
    match counts with 
        | [| var1; var2; var3; var4; var5; var6; var7 |] -> 
            (var2 + var4 + var6) = 0 || 
            (var2 = 10 && var4 = 10 && var6 = 10) || 
            (var1 = 5 && var3 = 5 && var5 = 5 && var7 = 5)
        | _ -> false
