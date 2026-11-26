USING: kernel sequences combinators combinators.short-circuit sorting math.statistics assocs ;
IN: yacht

: sum-matching ( dice n -- sum )
    swap [ = ] with filter sum ;

: all-same? ( dice -- ? )
    [ first ] keep [ = ] with all? ;

: score ( dice category -- score )
    {
      { "ones" [ 1 sum-matching ] }
      { "twos" [ 2 sum-matching ] }
      { "threes" [ 3 sum-matching ] }
      { "fours" [ 4 sum-matching ] }
      { "fives" [ 5 sum-matching ] }
      { "sixes" [ 6 sum-matching ] }
      { "full house" [ [ histogram values sort { 2 3 } = ] [ sum ] [ drop 0 ] 1if ] }
      { "four of a kind" [ 
        sort 
        { 
          [ 4 head [ all-same? ] 1guard ] 
          [ 4 tail* [ all-same? ] 1guard ] 
          [ drop { } ]
        } 1|| sum
      ] }
      { "little straight" [ sort { 1 2 3 4 5 } = [ 30 ] [ 0 ] if ] }
      { "big straight" [ sort { 2 3 4 5 7 } = [ 30 ] [ 0 ] if ] }
      { "choice" [ sum ] }
      { "yacht" [ all-same? [ 50 ] [ 0 ] if ] }
    } case ;
