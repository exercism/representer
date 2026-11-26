module KindergartenGarden

type Plant =
    | Grass
    | Clover
    | Radishes
    | Violets
    | None

let charToPlant (c: char) =
    match (c.ToString().ToUpper()) with
    | "G" -> Grass
    | "C" -> Clover
    | "R" -> Radishes
    | "V" -> Violets
    | _ -> None

let students =
    [| "Alice"
       "Bob"
       "Charlie"
       "David"
       "Eve"
       "Fred"
       "Ginny"
       "Harriet"
       "Ileana"
       "Joseph"
       "Kincaid"
       "Larry" |]

let plantsPerStudent = 4

let stringToPlants (str: string) =
    let plantArray =
        Array.map charToPlant <| str.ToCharArray()

    plantArray

let plantPlots rows =
    let topRow = Array.item 0 rows |> Array.chunkBySize 2
    let bottomRow = Array.item 1 rows |> Array.chunkBySize 2

    Array.map2 (fun (x: Plant []) (y: Plant []) -> Array.concat [ x; y ] |> Array.toList) topRow bottomRow

let parseDiagram (diagram: string) =
    let strRows = diagram.Split "\n"
    let rows = Array.map stringToPlants strRows

    plantPlots rows


let plants diagram student =
    let plantPlots = parseDiagram diagram

    let numStudents = (diagram.Length - 1) / plantsPerStudent // remove the newline from count

    let ownership =
        Map
        <| Array.zip (Array.take numStudents students) plantPlots

    ownership[ student ]
