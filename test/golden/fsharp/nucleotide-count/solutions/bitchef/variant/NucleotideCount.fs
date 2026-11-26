module NucleotideCount

let nucleotideCounts (strand: string): Option<Map<char, int>> =
    let tally = [ ('A', 0); ('C', 0); ('G', 0); ('T', 0) ]
                |> Map.ofList

    let rec count acc = function
        | [] -> Some acc
        | nuc::ns when Map.containsKey nuc acc ->
                let update = acc |> Map.add nuc (acc.[nuc] - 1)
                count update ns
        | _otherwise -> None

    strand |> Seq.toList |> count tally
