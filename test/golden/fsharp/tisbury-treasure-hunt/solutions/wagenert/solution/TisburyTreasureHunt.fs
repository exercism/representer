module TisburyTreasureHunt

let getCoordinate (line: string * string): string =
    let (_, coordinate) = line
    coordinate 

let convertCoordinate (coordinate: string): int * char = 
    let lastIndex = String.length coordinate - 1 
    let lastButOneIndex = lastIndex - 1
    let number = coordinate[0..lastButOneIndex] |> int
    let sector = coordinate[lastIndex]
    (number, sector)

let compareRecords (azarasData: string * string) (ruisData: string * (int * char) * string) : bool = 
    let azarasCoordinate = 
        getCoordinate azarasData
        |> convertCoordinate
    let (_, ruisCoordinate, _) = ruisData
    azarasCoordinate = ruisCoordinate

let createRecord (azarasData: string * string) (ruisData: string * (int * char) * string) : (string * string * string * string) =
    if compareRecords azarasData ruisData then
        let (treasure, coordinate) = azarasData
        let (location, _, color) = ruisData
        (coordinate, location, color, treasure)
    else
        ("", "", "", "")
