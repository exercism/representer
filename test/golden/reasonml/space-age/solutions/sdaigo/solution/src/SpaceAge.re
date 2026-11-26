type planet =
  | Mercury
  | Venus
  | Earth
  | Mars
  | Jupiter
  | Saturn
  | Neptune
  | Uranus;

let fixedWith2 = (f: float) =>
  float_of_string(Js.Float.toFixedWithPrecision(f, ~digits=2));

let secondsInOneEarthYear = 31557600.0;
let orbitalPeriodInEarthYears = (planet: planet) =>
  switch (planet) {
  | Mercury => 0.2408467
  | Venus => 0.61519726
  | Earth => 1.0
  | Mars => 1.8808158
  | Jupiter => 11.862615
  | Saturn => 29.447498
  | Neptune => 164.79132
  | Uranus => 84.016846
  };

let calc = (planet: planet, sec: float) =>
  fixedWith2(
    sec /. (secondsInOneEarthYear *. orbitalPeriodInEarthYears(planet)),
  );

let ageOn = (planet: planet, sec: float): float => {
  let calcWithPlanet = calc(planet);
  switch (planet) {
  | Mercury => calcWithPlanet(sec)
  | Venus => calcWithPlanet(sec)
  | Earth => calcWithPlanet(sec)
  | Mars => calcWithPlanet(sec)
  | Jupiter => calcWithPlanet(sec)
  | Saturn => calcWithPlanet(sec)
  | Neptune => calcWithPlanet(sec)
  | Uranus => calcWithPlanet(sec)
  };
};