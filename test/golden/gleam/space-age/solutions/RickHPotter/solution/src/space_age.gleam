pub type Planet {
  Mercury
  Venus
  Earth
  Mars
  Jupiter
  Saturn
  Uranus
  Neptune
}

const earth_year_in_seconds = 31_557_600.0

pub fn age(planet: Planet, seconds: Float) -> Float {
  seconds /. orbital_period(planet)
}

fn orbital_period(planet: Planet) -> Float {
  case planet {
    Mercury -> earth_year_in_seconds *. 0.2408467
    Venus -> earth_year_in_seconds *. 0.61519726
    Earth -> earth_year_in_seconds *. 1.0
    Mars -> earth_year_in_seconds *. 1.8808158
    Jupiter -> earth_year_in_seconds *. 11.862615
    Saturn -> earth_year_in_seconds *. 29.447498
    Uranus -> earth_year_in_seconds *. 84.016846
    Neptune -> earth_year_in_seconds *. 164.79132
  }
}
