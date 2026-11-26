USING: kernel math dlists deques sequences sets assocs arrays combinators combinators.smart ;
IN: pirates-path

: tide-queue ( items -- popped )
    [ <dlist> ] dip 
    [ over push-back ] each
    { } clone
    [ over deque-empty? ] [ over pop-front suffix ] until 
    nip ;

:: coves-reachable ( start chart -- coves )
    <dlist> start over push-back :> frontier
    HS{ } clone :> visited
    [ frontier deque-empty? ] [ 
      frontier pop-front
      [ visited in? not ] [
        [ chart at frontier push-all-back ] [ visited adjoin ] bi
      ] smart-when*
    ] until
    visited ;

:: hop-count ( start goal chart -- n/f )
    <dlist> { start 0 } over push-back :> frontier
    HS{ } clone :> visited
    f :> res!
    [ frontier deque-empty? res or ] [
      frontier pop-front
      { 
        { [ [ first goal = ] 1check ] [ second res! ] }
        { 
          [ [ first visited in? not ] 1check ] 
          [ first2 
            [ swap chart at [ swap 1 - 2array ] with map frontier push-all-back ] 
            [ drop visited adjoin ] 
            2bi 
          ] 
        }
        [ drop ]
      } cond
    ] until 
    res ;

CONSTANT: gold-distribution H{
    { "Hidden Cove"        80 }
    { "Skull Bay"         120 }
    { "Reef Point"         40 }
    { "Smuggler's Hollow" 200 }
    { "Plank Island"       60 }
    { "Lantern Rock"      150 }
}

MEMO: gold-count ( cove -- n )
    gold-distribution at [ 0 ] unless* ;

: treasure-route ( start chart -- best-cove )
    coves-reachable members [ gold-count ] maximum-by ;
