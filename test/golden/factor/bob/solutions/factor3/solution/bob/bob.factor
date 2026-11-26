USING: ascii combinators kernel regexp sequences sets ;
IN: bob

:: response ( str -- str )
    str [ blank? ] trim-tail "?" tail? :> question?
    str R/ (?=.*[A-Z])[^a-z]*/ matches? :> yelling?
    {
        { [ yelling? question? and ] [ "Calm down, I know what I'm doing!" ] }
        { [ yelling? ] [ "Whoa, chill out!" ] }
        { [ question? ] [ "Sure." ] }
        { [ str " \n\t\r" subset? ] [ "Fine. Be that way!" ] }
        [ "Whatever." ]
    } cond ;