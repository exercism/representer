class Bob {
    static String response(String input) {
        input = input.trim()
        Boolean isYelling = !(input =~ "[a-z]") && input =~ "[A-Z]"
        Boolean isQuestion = input.endsWith("?")
        if (!input)                       "Fine. Be that way!"
        else if (isQuestion && isYelling) "Calm down, I know what I'm doing!"
        else if (isQuestion)              "Sure."
        else if (isYelling)               "Whoa, chill out!"
        else                              "Whatever."
    }
}