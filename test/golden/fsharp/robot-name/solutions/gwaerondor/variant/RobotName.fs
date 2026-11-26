module RobotName

let mutable taken = []
let r = System.Random()
let letters = ['A'..'Z']
let numbers = ['0'..'9']
let shuffle = List.sortBy (fun _ -> r.Next())

let generateName () =
  (shuffle letters |> List.take 3) @ (shuffle numbers |> List.take 3)
  |> Seq.map string
  |> String.concat ""

let rec mkRobot () =
  let name = generateName () in
  if List.contains name taken then mkRobot ()
  else
    taken <- name :: taken
    name
  
let name robot = robot

let reset robot =
  taken <- List.except [robot] taken
  generateName ()
