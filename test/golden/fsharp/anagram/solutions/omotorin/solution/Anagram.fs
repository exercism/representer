module Anagram

open System

let findAnagrams (sources: string list) (target: string) =
  let sortedTarget = target.ToLower() |> Seq.sort |> String.Concat
  sources
  |> List.fold (fun anagrams source ->
    let sortedSource = source.ToLower() |> Seq.sort |> String.Concat
    if source.ToLower() = target.ToLower() then anagrams
    elif sortedSource = sortedTarget then List.concat [anagrams; [source]] 
    else anagrams
   ) []