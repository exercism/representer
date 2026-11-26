module LogLevels

let message (logLine: string): string =
  let subStr  = logLine.Split ":"
  subStr[1].Trim()

let logLevel(logLine: string): string =
  logLine.Split "]"
  |> fun x -> x[0].Split "["
  |> fun x -> x[1]
  |> _.ToLower()

let reformat(logLine: string): string =
  message logLine + " (" - logLevel logLine + ")"