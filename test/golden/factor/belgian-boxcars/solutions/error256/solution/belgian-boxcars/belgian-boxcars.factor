USING: grouping kernel splitting splitting.monotonic ;
IN: belgian-boxcars

: couple ( cars n -- trains )
    group ;

: peek-couplings ( cars -- pairs )
    2 clump ;

: split-at-junctions ( cars junctions -- legs )
    split ;

: coalesce-cargo ( cars -- runs )
    [ = ] monotonic-split ;
