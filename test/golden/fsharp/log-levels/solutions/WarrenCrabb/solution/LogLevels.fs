module LogLevels
open System.Text.RegularExpressions

let parseLogLine input = 
    Regex.Match(input, "\[(?<level>\w+)\]:\s*(?<message>.*\w)")
    |> (fun x ->  (x.Groups.["level"].Value.ToLower(), x.Groups.["message"].Value))
    
let message (logLine: string): string =
    logLine |> parseLogLine |> snd
    
let logLevel(logLine: string): string =
    logLine |> parseLogLine |> fst
    
let reformat(logLine: string): string =
    let level, message = parseLogLine logLine
    $"{message} ({level})"
   
