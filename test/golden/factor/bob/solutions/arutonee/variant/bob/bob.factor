USING: combinators kernel sequences unicode ;
IN: bob

:: response ( str -- str )
    str [ blank? ] trim              :> cleaned
    cleaned "?" tail?                :> question?
    cleaned [ LETTER? ] any?
    cleaned [ letter? ] any? not or :> yell?
    { { [ yell? question? and ] [ "Calm down, I know what I'm doing!" ] }
      { [ question? ]           [ "Sure." ] }
      { [ yell? ]               [ "Whoa, chill out!" ] }
      { [ cleaned "" = ]        [ "Fine. Be that way!" ] }
                                [ "Whatever." ] } cond ;
