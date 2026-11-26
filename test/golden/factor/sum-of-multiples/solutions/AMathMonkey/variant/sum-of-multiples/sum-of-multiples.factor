USING: kernel sets math sequences sets ;
IN: sum-of-multiples

:: sum-of-multiples ( factors limit -- sum )
    f fast-set
    factors [ 1 > ] filter 
    [ 
      dup :> fac 
      [ [ limit < ] 1check ] [ 2dup swap adjoin fac + ] while drop
    ] each 
    members sum ;
