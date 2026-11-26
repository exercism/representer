module Anagram exposing (detect)


detect : String -> List String -> List String
detect word candidates =
    let
        isAnagram : List Char -> List Char -> Bool
        isAnagram remainingCharsFromWord potentialAnagram =
            let
                notAnagram =
                    List.length remainingCharsFromWord /= List.length potentialAnagram
            in
            if notAnagram then
                False

            else
                case remainingCharsFromWord of
                    first :: rest ->
                        let
                            removeFirstInstanceOfChar : Char -> List Char -> List Char
                            removeFirstInstanceOfChar c l =
                                case l of
                                    fc :: rc ->
                                        if Char.toLower fc == Char.toLower c then
                                            rc

                                        else
                                            fc :: removeFirstInstanceOfChar c rc

                                    [] ->
                                        []
                        in
                        isAnagram rest (removeFirstInstanceOfChar first potentialAnagram)

                    [] ->
                        True

        recurDetect : List String -> List String -> List String
        recurDetect discoveredAnagrams remainingCandidates =
            case remainingCandidates of
                candidate :: rest ->
                    let
                        notAlreadyInDiscoveredAnagramList =
                            discoveredAnagrams
                                |> List.any (\w -> String.toLower w == String.toLower candidate)
                                |> not
                    in
                    if
                        notAlreadyInDiscoveredAnagramList
                            && isAnagram (String.toList word) (String.toList candidate)
                    then
                        recurDetect (candidate :: discoveredAnagrams) rest

                    else
                        recurDetect discoveredAnagrams rest

                [] ->
                    discoveredAnagrams

        removeWordFromCandidateList =
            List.filter (\w -> String.toLower w == String.toLower word)
    in
    candidates
        |> removeWordFromCandidateList
        |> recurDetect []
        |> List.reverse
