type planet =
  | Mercury
  | Venus
  | Earth
  | Mars
  | Jupiter
  | Saturn
  | Neptune
  | Uranus;

let earthYearInSeconds = 31557600.;

let ageOn = (planet, x) => {
    switch (planet) {
        | Mercury => x /. (earthYearInSeconds *. 0.2408467)
        | Venus => x /. (earthYearInSeconds *. 0.61519726)
        | Earth => x /. earthYearInSeconds
        | Mars => x /. (earthYearInSeconds *. 1.8808159)
        | Jupiter => x /. (earthYearInSeconds *. 11.862615)
        | Saturn => x /. (earthYearInSeconds *. 29.447498)
        | Neptune => x /. (earthYearInSeconds *. 164.79132)
        | Uranus => x /. (earthYearInSeconds *. 84.016846)
    }
}
