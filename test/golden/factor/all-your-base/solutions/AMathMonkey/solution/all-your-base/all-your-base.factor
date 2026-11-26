USING: kernel sequences math math.functions math.order combinators ;
IN: all-your-base

: to-base10 ( input-base digits -- n )
    reverse [ ^ * ] with map-index sum ;

: to-baseN ( n base -- digits )
     1 [ [ pick > ] 1check ] [ over * ] until over /i
     [ [ 0 > ] 1check ] [
       { [ nip mod ] [ drop nip ] [ swap /i nip ] [ nip /i ] } 3cleave
     ] produce 3nip
     [ { 0 } clone ] when-empty ;

: rebase ( digits input-base output-base -- digits' )
    [
      [ "input" ] [ "output" ] bi*
      [ swap 2 < [ " base must be >= 2" append throw ] [ drop ] if ] 2bi@
    ] 2keep
    spin
    [ [ 0 rot 1 - between? ] with all? ]
    [ "all digits must satisfy 0 <= d < input base" throw ]
    2unless
    to-base10 swap to-baseN ;
