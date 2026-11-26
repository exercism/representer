namespace eval resistorColor {
    proc colorCode {args} {
        #set col {black brown red orange yellow green blue violet grey white}
        set i [lsearch -exact [colors] $args ]
        if {$i==-1} { 
        error "Invalid color: $args"
        }
        return $i
        
}
    proc colors {args} {
        return "black brown red orange yellow green blue violet grey white"
    }
}
