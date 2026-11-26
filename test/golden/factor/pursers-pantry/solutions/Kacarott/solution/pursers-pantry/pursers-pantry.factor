USING: kernel sequences math.statistics assocs math math.order sorting ;
IN: pursers-pantry

: create-inventory ( seq -- inventory )
    histogram ;

: add-items ( inventory items -- inventory' )
    [ clone ] dip histogram! ;

: decrement-items ( inventory items -- inventory' )
    swap clone tuck '[ _ [ 1 - 0 max ] ?change-at ] each ;

: remove-item ( inventory item -- inventory' )
    swap clone tuck delete-at ;

: list-inventory ( inventory -- pairs )
    >alist [ last zero? ] reject sort ;
