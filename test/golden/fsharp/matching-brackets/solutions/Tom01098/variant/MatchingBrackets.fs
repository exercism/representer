module MatchingBrackets

let isPaired input = 
    let rec removePairs (str: string) =
        let newStr = 
            str
                .Replace("()", "")
                .Replace("[]", "")
                .Replace("{}", "")
        if newStr = str then str
        else removePairs newStr
    
    let isBracket (c: char) = "()[]{}".Contains(c)

    let pairsRemoved =
        input
        |> String.filter isBracket
        |> removePairs

    String.length pairsRemoved = 1