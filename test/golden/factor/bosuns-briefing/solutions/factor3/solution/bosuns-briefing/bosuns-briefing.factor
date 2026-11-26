USING: bosuns-briefing.helpers formatting kernel sequences ;
IN: bosuns-briefing

: roster ( names -- str )
    [ crew-line ] map "\n" join ;

: briefing ( names -- str )
    greeting swap roster closing "%s\n%s\n%s" sprintf ;