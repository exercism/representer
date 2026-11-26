type planet =
  | Mercury
  | Venus
  | Earth
  | Mars
  | Jupiter
  | Saturn
  | Neptune
  | Uranus;

let ageOn = (planet, seconds) => {
  let earthYears = seconds /. 31557600.;
  switch (planet) {
  | Mercury => earthYears /. 0.2408467
  | Venus => earthYears /. 0.61519726
  | Earth => earthYears
  | Mars => earthYears /. 1.8808158
  | Jupiter => earthYears /. 11.862615
  | Saturn => earthYears /. 29.447498
  | Uranus => earthYears /. 84.016846
  | Neptune => earthYears /. 164.79132
  };
};