module KindergartenGarden

// TODO: define the Plant type

type Plant =
    | Violets
    | Radishes
    | Clover
    | Grass

let charToPlant (str: char) =
    match str with
    | 'V' -> Violets
    | 'R' -> Radishes
    | 'C' -> Clover
    | 'G' -> Grass
    | _ -> failwith "Unknown"

let getStudentOffset (student: string) =
    [ 'a' .. 'z' ]
    |> List.findIndex (fun x -> x = student.ToLower().[0])
    |> (*) 2


let strToPlants (str: string) = str |> Seq.map charToPlant

let plants (diagram: string) (student: string) =

    let offset = getStudentOffset student

    diagram.Split("\n")
    |> Array.map (fun s -> s.Substring(offset, 2) |> strToPlants)
    |> Seq.concat
    |> Seq.toList
