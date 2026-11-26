datatype planet = Mercury | Venus | Earth | Mars
                | Jupiter | Saturn | Neptune | Uranus

fun age_on planet seconds =
    let val time = (Real.fromInt seconds)/31557600.0 in
    case planet of
    Mercury => time/ 0.2408467
    |Venus => time/0.61519726
    |Earth => time
    |Mars => time/ 1.8808158
    |Jupiter => time/ 11.862615 
    |Saturn => time/29.447498
    |Uranus => time/84.016846
    |Neptune => time/ 164.79132 
end