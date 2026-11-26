USING: ascii sequences.extras sets ;
IN: isogram

: isogram? ( phrase -- ? )
    [ Letter? ] [ ch>lower ] filter-map all-unique? ;
