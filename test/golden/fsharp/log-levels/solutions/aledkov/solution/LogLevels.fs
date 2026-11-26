module LogLevels

let message (logLine: string): string = logLine.Replace("[INFO]:", "").Replace("[WARNING]:", "").Replace("[ERROR]:", "").Trim()

let logLevel(logLine: string): string = logLine.Substring(1, logLine.IndexOf(']') - 1).ToLower()

let reformat(logLine: string): string = sprintf "%s (%s)" (message logLine) (logLevel logLine)
