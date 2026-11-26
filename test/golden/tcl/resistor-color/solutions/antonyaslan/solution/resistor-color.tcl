namespace eval resistorColor {
    proc colorCode {color} {
        set colours [dict create black 0 brown 1 red 2 orange 3 yellow 4 green 5                                     blue 6 violet 7 grey 8 white 9]
        foreach item [dict keys $colours] {
            set number [dict get $colours $item]
            if {$item == $color} {
                return $number
            }
        }
        error "Invalid color: $color"
    }

    proc colors {} {
        set color_list "black brown red orange yellow green blue violet grey white"
        return $color_list
    }
}