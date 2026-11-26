USING: kernel regexp sequences sets hashtables assocs math math.functions math.combinatorics ranges generalizations ;
IN: alphametics

: sums ( words -- assoc )
    H{ } clone tuck [ dup length 1 - ] dip '[
        _ = -1 1 ?
        [ swap 10^ / [ swap 0 or + ] curry _ swap change-at ] curry each-index
    ] each-index ;

: non-zero ( words -- set )
    [ last ] map members ;

: sum-satisfied? ( sum mapping -- ? )
    >alist [ first2 [ of ] dip * ] with map sum zero? ;  

: solve ( puzzle -- mapping/f )
    R/ [A-Z]+/ all-matching-subseqs [ reverse ] map
    [ non-zero ] [ sums ] bi dup keys
    { 1 5 4 6 3 7 2 8 9 0 } over length <k-permutations>
    [| nz ss ks p |
        ks p zip :> mapping
        nz [ mapping at zero? ] any?
        [ f ]
        [ ss mapping sum-satisfied? mapping and ]
        if
    ] 3 nwith map-find [ >hashtable ] when ;
