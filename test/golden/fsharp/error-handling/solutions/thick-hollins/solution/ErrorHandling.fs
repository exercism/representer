module ErrorHandling

open System

let handleErrorByThrowingException () = raise (Exception("message"))

let handleErrorByReturningOption input = 
    match input with
    | "1" -> Some 1
    | _ -> None

let handleErrorByReturningResult input =
    match input with
    | "1" -> Ok 1
    | _ -> Error "Could not convert input to integer"

let bind switchFunction twoTrackInput = 
    match twoTrackInput with
    | Ok i -> switchFunction i
    | Error ex -> Error ex

let cleanupDisposablesWhenThrowingException resource = 
    using resource (fun r -> raise (Exception("message")))