module KindergartenGarden

type Plant = Grass | Clover | Radishes | Violets
    
let fromChar: char -> Plant = function
    | 'V' -> Violets
    | 'G' -> Grass
    | 'R' -> Radishes
    | 'C' -> Clover
    | _ -> failwith "Plant type not found"
    
let getStudentIndex: string -> int = function
    | "Alice" -> 0
    | "Bob" -> 1
    | "Charlie" -> 2
    | "David" -> 3
    | "Eve" -> 4
    | "Fred" -> 5
    | "Ginny" -> 6
    | "Harriet" -> 7
    | "Ileana" -> 8
    | "Joseph" -> 9
    | "Kincaid" -> 10
    | "Larry" -> 11
    | _ -> failwith "Student not found"

let toCharArray (s: string) = s.ToCharArray ()
let to2dArray (s: string) =
    s.Split ()
    |> Array.map toCharArray
    |> Array.map (Array.map fromChar)
    |> array2D

let getPlantsByIndex (diagram: Plant[,]) (studentIndex: int) =
    let startColumn = studentIndex * 2
    let get = Array2D.get diagram
    [
        get 0 startColumn
        get 0 (startColumn + 1)
        get 1 startColumn
        get 1 (startColumn + 1)
    ]
    
let plants diagram student =
    let array = to2dArray diagram
    let studentIndex = getStudentIndex student
    getPlantsByIndex array studentIndex