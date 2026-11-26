module ResistorColor

open System.Collections.Frozen
open System.Collections.Generic

let colors: string list = ["black"; "brown"; "red"; "orange"; "yellow"; "green"; "blue"; "violet"; "grey"; "white"]
let colorLookup = colors |> Seq.mapi (fun i c -> KeyValuePair(c, i)) |> FrozenDictionary.ToFrozenDictionary

let colorCode (color: string): int = colorLookup[color]
