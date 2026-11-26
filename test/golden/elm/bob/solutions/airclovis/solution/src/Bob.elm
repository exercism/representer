module Bob exposing (hey)


hey : String -> String
hey remark =
    let 
        isEmpty = String.isEmpty << String.trim
        isQuestion = String.endsWith "?" << String.trimRight
        isCapsLock input = String.toUpper input == input
        containsLetter = List.any (\l -> Char.isAlpha l) << String.toList
    in
    if isEmpty remark then
        "Fine. Be that way!"
    else if isQuestion remark then
        if isCapsLock remark && containsLetter remark then
            "Calm down, I know what I'm doing!"
        else
            "Sure."
    else if isCapsLock remark && containsLetter remark then
        "Whoa, chill out!"
    else
        "Whatever."
