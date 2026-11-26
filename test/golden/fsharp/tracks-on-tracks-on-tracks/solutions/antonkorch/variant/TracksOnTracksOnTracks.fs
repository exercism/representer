module TracksOnTracksOnTracks

let newList: string list = 
    []
let existingList: string list =
    [ "F#"; "Clojure"; "Haskell" ]

let addLanguage (language: string) (languages: string list): string list =
    language :: languages

let countLanguages (languages: string list): int = 
    languages.Length

let reverseList(languages: string list): string list = 
    List.rev languages
let excitingList (languages: string list): bool = 
    match languages with
    | h :: t when h = "F#" -> true
    | _ :: h :: t when h = "F#" && countLanguages languages > 1 || countLanguages languages < 4 -> true
    | _ -> false