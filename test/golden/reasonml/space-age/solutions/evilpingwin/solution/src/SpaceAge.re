type planet =
  | Mercury
  | Venus
  | Earth
  | Mars
  | Jupiter
  | Saturn
  | Neptune
  | Uranus;

let planetDivisor = planet =>
  switch (planet) {
  | Earth => 1.0
  | Mercury => 0.2408467
  | Venus => 0.61519726
  | Mars => 1.8808158
  | Jupiter => 11.862615
  | Saturn => 29.447498
  | Uranus => 84.016846
  | Neptune => 164.79132
  };

let toEarthDays = seconds => seconds /. 60.0 /. 60.0 /. 24.0 /. 365.25;

let ageOn = (planet, age) => toEarthDays(age) /. planetDivisor(planet);