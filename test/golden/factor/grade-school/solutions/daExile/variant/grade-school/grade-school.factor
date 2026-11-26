USING: kernel assocs accessors arrays sequences sorting ;
IN: grade-school

! a simple hashtable H{ { name grade } } seems good enough for take 1
TUPLE: school students ;

: <school> ( -- school ) H{ } clone school boa ;

: add-student ( school name grade -- ? )
    spin students>> 2dup key? [ 3drop f ] [ set-at t ] if ;

: roster ( school -- names )
    students>> [ 2array ] { } assoc>map
    [ first ] sort-by [ second ] sort-by [ last ] map ;

: grade ( school n -- names )
    [ students>> ] dip '[ _ = ] filter-values [ drop ] { } assoc>map sort ;