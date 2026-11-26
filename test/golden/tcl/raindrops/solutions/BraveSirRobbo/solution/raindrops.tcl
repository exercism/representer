proc raindrops {number} {

    if { ![expr {$number % 3}] } { append output "Pling"}
    if { ![expr {$number % 5}] } { append output "Plang"}
    if { ![expr {$number % 7}] } { append output "Plong"}
    if { ![info exists output] } { return $number }

    return $output
}
