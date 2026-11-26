export function age(planet: (keyof typeof PLANET_PERIOD), seconds: number): number {
  return  +(seconds / PLANET_PERIOD[planet] / SECONDS_IN_YEAR).toFixed(2);
}

const SECONDS_IN_YEAR: number = 31557600;

const PLANET_PERIOD = {
  "mercury": 0.2408467,
  "venus": 0.61519726,
  "earth": 1.0,
  "mars": 1.8808158,
  "jupiter": 11.862615,
  "saturn": 29.447498,
  "uranus": 84.016846,
  "neptune": 164.79132
}
