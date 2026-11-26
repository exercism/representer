module LogLevels

open System.Text.RegularExpressions

let (|Regex|_|) (pattern: string) (input: string) =
  match Regex.Match(input, pattern) with
  | m when m.Success -> Some [for g in m.Groups -> g.Value]
  | _ -> None

let message (logLine: string): string =
  match logLine with
  | Regex @"^\[\w+\]: (.*)$" [_; msg] -> msg.Trim()
  | _ -> logLine

let logLevel(logLine: string): string =
  match logLine with
  | Regex @"^\[(.*)\]" [_;level] -> level.ToLower()
  | _ -> logLine

let reformat(logLine: string): string = 
  $"{message logLine} ({logLevel logLine})"
