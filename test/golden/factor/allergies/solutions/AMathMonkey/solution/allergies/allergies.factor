USING: kernel math sequences.extras sets qw ;
IN: allergies

CONSTANT: all-allergens qw{ eggs peanuts shellfish strawberries tomatoes chocolate pollen cats }

: allergens ( score -- set )
    all-allergens [ nipd bit? ] with filter-index fast-set ;

: allergic-to ( score item -- ? )
    swap allergens in? ;
