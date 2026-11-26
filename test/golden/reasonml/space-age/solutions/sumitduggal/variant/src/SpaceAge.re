type planet =
  | Mercury
  | Venus
  | Earth
  | Mars
  | Jupiter
  | Saturn
  | Neptune
  | Uranus;

let getEquivalentEarthSeconds = (planet): float => {
  let earthSeconds = float_of_int(31557600);
  switch planet {
    | Mercury => earthSeconds *. 1.2408467;
    | Venus => earthSeconds *. 0.61519726;
    | Earth => earthSeconds;
    | Mars => earthSeconds *. 1.8808158;
    | Jupiter => earthSeconds *. 11.862615;
    | Saturn => earthSeconds *. 29.447498;
    | Uranus => earthSeconds *. 84.016846;
    | Neptune => earthSeconds *. 164.79132;
  }
}

let ageOn = (planet, float): float =>
  planet
    |> getEquivalentEarthSeconds
    |> (earthSeconds) => float /. earthSeconds
