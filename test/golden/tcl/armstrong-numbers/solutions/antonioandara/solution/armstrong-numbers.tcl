proc isArmstrongNumber {number} {
set total 0
set power [string length $number]
foreach n [split $number ""] {
    set total [expr {$total +$n**$power}]
    }
return [expr {$total == $number ? true : false}]                
}
