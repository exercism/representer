USING: kernel grouping splitting splitting.monotonic sequences ;
IN: belgian-boxcars

: couple ( cars n -- trains ) group ;

: peek-couplings ( cars -- pairs ) 3 clump ;

: split-at-junctions ( cars junctions -- legs ) [ member? ] curry split-when ;

: coalesce-cargo ( cars -- runs ) [ = ] monotonic-split ;
