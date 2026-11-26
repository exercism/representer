USING: ascii grouping kernel math sequences ;
IN: atbash-cipher

: encode ( phrase -- str )
    [ alpha? ] filter >lower
    [ dup letter? [ CHAR: z swap + CHAR: a + ] when ] map
    5 group " " join ;

: decode ( phrase -- str )
    encode [ blank? ] reject ;
