namespace eval resistorColor {

    proc colorCode {k} {
        set i [ lsearch -exact [colors] $k ]
        return [ expr { $i == -1 ? [error "Invalid color: $k"] : $i } ]
    }

    proc colors {args} {
        return { black brown red orange yellow green blue violet grey white }
    }

}
