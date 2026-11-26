datatype planet = Mercury | Venus | Earth | Mars
                | Jupiter | Saturn | Uranus | Neptune

fun yearsOnEarth seconds = (real seconds) / (real 31557600)

fun age_on planet seconds = 
  case planet of
  Earth => yearsOnEarth seconds
  | Mercury => yearsOnEarth seconds / 0.2408467
  | Venus =>  yearsOnEarth seconds / 0.61519726
  | Mars => yearsOnEarth seconds / 1.8808158
  | Jupiter => yearsOnEarth seconds / 11.862615
  | Saturn => yearsOnEarth seconds / 29.447498
  | Uranus => yearsOnEarth seconds / 84.016846
  | Neptune => yearsOnEarth seconds / 164.79132