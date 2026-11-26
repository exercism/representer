USING: kernel ;
USING: math ;
IN: lasagna

CONSTANT: expected-bake-time 40

: preparation-time ( layers -- minutes )
    3 * ;

: remaining-time ( current-time -- remaining )
    expected-bake-time swap - ;

: total-working-time ( layers current-time -- minutes )
    swap preparation-time + ;
