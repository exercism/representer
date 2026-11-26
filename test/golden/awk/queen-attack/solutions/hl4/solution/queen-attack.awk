@include "assert"
BEGIN {

}

{
    assert(bound($1) &&
           bound($2) &&
           bound($3) &&
           bound($4) &&
           ($1 != $3 || $2 != $4),
           "invalid")

    out = "false"
    if ($1 == $3 || $2 == $4 || $1 + $2 == $3 + $4 || $1 - $2 == $3 - $4) {
        out = "true"
    }
    print out
}


function bound(x) {
    return x >= 0 && x < 8
}