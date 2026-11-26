module TracksOnTracksOnTracks

let newList: string list = []

let existingList: string list = [ "F#"; "Clojure"; "Haskell" ]

let addLanguage (language: string) (languages: string list) : string list = language :: languages

let countLanguages (languages: string list) : int = languages.Length

let reverseList (languages: string list) : string list =
    //Could use List.reverse but this is more educational for me.
    let rev list =
        let rec loop acc =
            function
            | [] -> acc
            | head :: tail -> loop (head :: acc) tail

        loop [] list

    rev languages

let excitingList (languages: string list) : bool =
    match languages with
    | "F#" :: _
    | [ _; "F#" ]
    | [ _; "F#"; _ ] -> true
    | _ -> false
