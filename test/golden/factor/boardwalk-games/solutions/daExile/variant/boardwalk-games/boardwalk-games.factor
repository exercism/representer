USING: kernel random math random.mersenne-twister ;
IN: boardwalk-games

ALIAS: pick-prize random
ALIAS: shuffle-deck randomize
ALIAS: deal-hand sample

: roll-die ( sides -- n ) random 2 + ;

: play-seeded ( seed quot -- ) [ <mersenne-twister> ] dip with-random ; inline