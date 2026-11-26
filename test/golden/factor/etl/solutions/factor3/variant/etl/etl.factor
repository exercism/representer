USING: arrays ascii assocs hashtables kernel sequences ;
IN: etl

: transform ( legacy -- new )
    [ [ >lower ] filter dup length rot <array> zip ]
    { } assoc>map concat >hashtable ;
