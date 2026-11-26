USING: accessors kernel make random.data ;
IN: robot-name

TUPLE: robot name ;

: name ( -- str )
    [
        random-LETTER , random-LETTER ,
        random-digit , random-digit , random-digit ,
    ] "" make ;

: <robot> ( -- robot )
    name robot boa ;

: reset-name ( robot -- )
    name swap name<< ;