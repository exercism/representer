USING: kernel math math.functions random sequences accessors ;
IN: dnd-character

CONSTANT: d6 { 1 2 3 4 5 6 }

TUPLE: character
    strength dexterity constitution intelligence wisdom charisma hitpoints ;

: modifier ( score -- n ) 10 - 2 / floor >integer ;

: ability ( -- score ) 4 <iota> [ drop d6 random ] map [ sum ] [ minimum ] bi - ;

: <character> ( -- character )
    character new
        ability >>strength
        ability >>dexterity
        ability >>constitution
        ability >>intelligence
        ability >>wisdom
        ability >>charisma
        10 over constitution>> modifier + >>hitpoints ;