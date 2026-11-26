module WordSearch

type WordLocation = (int * int) * (int * int)

let search (grid : string list) (wordsToSearchFor : string list) : Map<string, WordLocation option> =
    let getChar (x, _, _) = x
    let getRow (_, r, _) = r
    let getCol (_, _, c) = c

    let gridCells =
        grid
        |> List.mapi (fun r row ->
               row
               |> Seq.toList
               |> List.mapi (fun c ch -> (ch, c + 1, r + 1)))
        |> List.concat

    let rows = List.groupBy getRow >> List.map (snd >> List.sortBy getCol)
    let rowsRev = rows >> List.map List.rev
    let columns = List.groupBy getCol >> List.map (snd >> List.sortBy getRow)
    let columnsRev = columns >> List.map List.rev
    let diagonals =
        List.groupBy (fun (_, r, c) -> r - c)
        >> List.map (snd >> List.sortBy getRow)
    let diagonalsRev = diagonals >> List.map List.rev
    let antiDiag =
        List.groupBy (fun (_, r, c) -> r + c)
        >> List.map (snd >> List.sortBy getCol)
    let antiDiagRev = antiDiag >> List.map List.rev
    let allDirections =
        [ rows; rowsRev; columns; columnsRev; diagonals; diagonalsRev; antiDiag;
          antiDiagRev ] |> List.collect ((|>) gridCells)

    let findWordInLine (target : string) (line : (char * int * int) list) =
        let targetList = target |> Seq.toList
        if List.length targetList > List.length line then []
        else
            line
            |> List.windowed (List.length targetList)
            |> List.tryFind (fun words -> targetList = List.map getChar words)
            |> Option.toList
            |> List.concat

    let findWordInLines (word : string) (lines) =
        lines
        |> List.map (findWordInLine word)
        |> List.tryFind (List.isEmpty >> not)
        |> Option.map (fun lst ->
               let (_, r1, c1) = List.head lst
               let (_, r2, c2) = List.last lst
               ((r1, c1), (r2, c2)))

    wordsToSearchFor
    |> List.map (fun w -> (w, findWordInLines w allDirections))
    |> Map.ofList
