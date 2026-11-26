module LogLevels

let message (logLine: string): string =
  logLine[logLine.IndexOf ":" + 1..logLine.Length].Trim()

let logLevel(logLine: string): string =
  logLine[logLine.IndexOf "[" + 1..logLine.IndexOf "]" - 1].Trim().ToLowerInvariant()

let reformat(logLine: string): string =
  (message logLine) + " (" + (logLevel logLine) + ")"
