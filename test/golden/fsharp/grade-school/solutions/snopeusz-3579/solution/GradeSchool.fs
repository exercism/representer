module GradeSchool

type School = Map<int, string list>

let empty: School = School []

let add (student: string) (grade: int) (school: School) : School =
    if school.Values |> Seq.exists (List.contains student) then
        school
    else
        school
        |> Map.change grade (function
            | None -> Some [ student ]
            | Some xs -> Some(student :: xs |> List.sort))

let roster: School -> string list =
    Map.values >> List.concat

let grade (number: int) : School -> string list =
    Map.tryFind number >> Option.defaultValue []
