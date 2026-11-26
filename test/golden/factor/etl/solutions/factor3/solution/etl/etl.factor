USING: arrays ascii assocs hashtables kernel sequences ;
IN: etl

: transform ( legacy -- new )
    [ [ >lower ] map dup length rot <array> zip ]
    { } assoc>map concat >hashtable ;
