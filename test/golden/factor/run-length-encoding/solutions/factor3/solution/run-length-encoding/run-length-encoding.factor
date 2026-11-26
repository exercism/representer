USING: kernel math math.parser regexp sequences sequences.extras
splitting.monotonic strings ;
IN: run-length-encoding

: encode ( str -- encoded )
    [ = ] monotonic-split [
        [ length dup 1 = [ drop "" ] [ >dec ] if ]
        [ first ] bi suffix
    ] "" map-concat-as ;

: decode ( str -- decoded )
    R/ (\d+)?[a-zA-Z ]/ [
        dup length 1 >
        [ 1 cut* [ dec> ] dip first <string> ] when
    ] re-replace-with ;