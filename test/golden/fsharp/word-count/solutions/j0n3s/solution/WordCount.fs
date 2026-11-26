module WordCount

open System.Text.RegularExpressions

let countWords (phrase: string) =

    let cleaned = phrase.ToLowerInvariant()

    let parsed = Regex.Matches(cleaned, @"\b([a-z]+('[a-z]+)*|[0-9]+)\b")

    parsed
    |> seq
    |> Seq.countBy (fun s -> s.Value)
    |> Map.ofSeq
