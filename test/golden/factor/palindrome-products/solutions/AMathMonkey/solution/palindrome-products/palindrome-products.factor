USING: kernel math math.parser math.order ranges sequences pair-rocket arrays combinators combinators.short-circuit continuations sorting ;
IN: palindrome-products

: palindrome? ( n -- ? )
    number>string dup length 2 /i [ head-slice ] [ tail-slice* <reversed> ] 2bi sequence= ;

:: solve ( mn mx smallest? -- res factors )
    mn mx <= [ "min must be <= max" throw ] unless
    f V{ } clone :> ( res! facs )
    mn mx smallest? [ swap ] unless [a..b] [| i |
        [
            i smallest? [ mx ] [ mn ] if [a..b] [| j |
                i j * :> prod
                [ res ] => [ prod res <=> smallest? [ +gt+ ] [ +lt+ ] if eq? ] 0&& [ return ] when
                {
                    [ prod res = ] => [ i j 2array facs push ]
                    [ 
                        [ res [ prod swap <=> smallest? [ +lt+ ] [ +gt+ ] if eq? ] [ t ] if* ] => 
                        [ prod palindrome? ] 0&& 
                    ] => [ 
                        prod res!
                        i j sort-pair 2array facs [ delete-all ] keep push
                    ]
                    [ ]
                } cond
            ] each
        ] with-return
    ] each
    res facs >array ;

: smallest ( mn mx -- value factors )
    t solve ;

: largest ( mn mx -- value factors )
    f solve ;
