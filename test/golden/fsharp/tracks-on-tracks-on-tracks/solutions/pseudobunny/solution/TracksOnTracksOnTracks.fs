module TracksOnTracksOnTracks

let newList: string list = []

let existingList: string list = ["F#"; "Clojure"; "Haskell"]

let addLanguage (language: string) (languages: string list): string list =
    language::languages

let countLanguages (languages: string list): int = languages.Length

let reverseList(languages: string list): string list = 
    List.fold (fun newList lan -> lan::newList) [] languages

let excitingList (languages: string list): bool = 
    match languages with
    | [x; y] -> x = "F#" || y = "F#"
    | [x; y; _] -> x = "F#" || y = "F#"
    | head::tail -> head = "F#"
    | _ -> false
