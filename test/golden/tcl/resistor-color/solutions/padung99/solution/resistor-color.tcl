namespace eval resistorColor {
    # set res_colors [dict create black 0 brown 1 red 2 orange 3 yellow 4 green 5 blue 6 violet 7 grey 8 white 9]
    proc colorCode {args} {
        set res_colors [dict create black 0 brown 1 red 2 orange 3 yellow 4 green 5 blue 6 violet 7 grey 8 white 9]
        try {
            return [dict get $res_colors $args]
        } on error {} {
            error "Invalid color: $args"
        }
}

proc colors {} {
  #throw {NOT_IMPLEMENTED} "Implement this procedure."
  set res_colors [dict create black 0 brown 1 red 2 orange 3 yellow 4 green 5 blue 6 violet 7 grey 8 white 9]
  return [dict keys $res_colors]
}
# puts "first arg is: [lindex $argv 0]"
# puts "Second arg is: [lindex $argv 1]"

# set var [lindex $argv 1]

#   if {[string trim $var] != ""} {
#     puts [colorCode [lindex $argv 1]]
#   } else {
#     puts [colors]
#   }


}