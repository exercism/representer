type planet =
  | Mercury
  | Venus
  | Earth
  | Mars
  | Jupiter
  | Saturn
  | Neptune
  | Uranus;

let earthYears = (seconds: float) => seconds /. 31557600.0;
let ageOn = (planet: planet, seconds: float) => {
  let earthAge = earthYears(seconds);
  switch (planet) {
  | Mercury => earthAge /. 0.2408467
  | Venus => earthAge /. 0.61519726
  | Earth => earthAge
  | Mars => earthAge /. 1.8808158
  | Jupiter => earthAge /. 11.862615
  | Saturn => earthAge /. 29.447498
  | Neptune => earthAge /. 164.79132
  | Uranus => earthAge /. 84.016846
  };
};