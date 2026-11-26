USING: assocs kernel math.order math.statistics sequences sorting ;
IN: pursers-pantry

: create-inventory ( seq -- inventory )
    histogram ;

: add-items ( inventory items -- inventory' )
    [ clone ] dip histogram! ;

: decrement-items ( inventory items -- inventory' )
    [ clone ] dip over '[ _ [ 1 [-] ] ?change-at ] each  ;

: remove-item ( inventory item -- inventory' )
    swap clone tuck delete-at ;

: list-inventory ( inventory -- pairs )
    [ nip 0 = ] assoc-reject >alist sort ;
