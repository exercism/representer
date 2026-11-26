module TracksOnTracksOnTracks

let newList: string list = []

let existingList: string list = ["F#"; "Clojure"; "Haskell"]

let addLanguage (language: string) (languages: string list): string list =
    language :: languages

let countLanguages (languages: string list): int = languages.Length

let reverseList(languages: string list): string list = List.rev languages

let excitingList (languages: string list): bool = 
    match languages.Length with
    | 0 -> false
    | _ when languages[0] = "F#" -> true
    | 2 | 3 -> languages[1] = "F#"
    | _ -> false