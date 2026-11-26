module LogLevels

let message (logLine: string): string = 
    let splitLine = logLine.Split("]: ")
    splitLine[1].Trim()

let logLevel(logLine: string): string = 
    let subString = logLine.[1..]
    let split = subString.Split("]")
    split[0].ToLower()

let reformat(logLine: string): string = message logLine + " (" + logLevel logLine + ")"