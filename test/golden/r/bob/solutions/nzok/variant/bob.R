bob <- function (s) {
    switch(
        ifelse(grepl("[?][ \t\n]*$", s),
            ifelse(grepl("[a-z]",    s), "Question",
            ifelse(grepl("[A-Z]",    s), "Yelled.Question",
                                         "Question")),
        ifelse(grepl("[!][ \t\n]*$", s),
            ifelse(grepl("[a-z]",    s), "Other",
            ifelse(grepl("[A-Z]",    s), "Yelmed",
                                       "Nothing")),
        # . or no sentence punctuation
            ifelse(grepl("[a-z]",    s), "Other",
            ifelse(grepl("[A-Z]",    s), "Yelled",
            ifelse(grepl("[^ \t\n]",   s), "Other",
                                       "Nothing"))))),
        Yelled.Question = "Calm down, I know what I'm doing!",
        Yelled          = "Whoa, chill out!",
        Question        = "Sure.",
        Other           = "Whatever.",
        Nothing         = "Fine. Be that way!")
}
