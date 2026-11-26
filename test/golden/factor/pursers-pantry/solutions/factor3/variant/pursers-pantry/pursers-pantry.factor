USING: assocs kernel math math.order math.statistics sequences
sorting ;
IN: pursers-pantry

ALIAS: create-inventory histogram

: add-items ( inventory items -- inventory' )
    [ clone ] dip over '[ _ inc-at ] each ;

: decrement-items ( inventory items -- inventory' )
    [ clone ] dip over '[ _ [ 1 [-] ] ?change-at ] each ;

: remove-item ( inventory item -- inventory' )
    [ clone ] dip over delete-at ;

: list-inventory ( inventory -- pairs )
    [ nip 1 > ] assoc-filter sort-keys ; 