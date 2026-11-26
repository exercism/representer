#lang racket

(provide response-for)

(define (response-for prompt)

    ; Removes unneeded whitespace at the start and end of the prompt
    (define prep-prompt (string-trim prompt))
  
    ; Uses regex expression to search for a ? at the end of string
    (define question (if (regexp-match #px"\\?$" prep-prompt) #true #false))

    ; Uses regex expression to search for all the word segments in a string
    (define words (regexp-match* #px"[a-zA-Z]+" prep-prompt))

    ; Uses regex expression to ensure all word segments are in capital letters
    (define yell (and (not (null? words)) (for/and ([w words]) (regexp-match? #px"^[A-Z]+$" w))))

    ; Determines if a string is both a yell and question
    (define yelledQuestion (or question yell))

    ; Determines if a string is only whitespace with regex expressions
    (define silence (if (regexp-match #px"^\\s*$" prep-prompt) #true #false))

    (cond

        [silence "Fine. Be that way!"]

        [yelledQuestion "Calm down, I know what I'm doing!"]

        [yell "Whoa, chill out!"]

        [question "Sure."]
        
        [else "Whatever."]

    )
)

