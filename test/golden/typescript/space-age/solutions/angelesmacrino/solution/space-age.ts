export const SECONDS_EARTH_YEAR = 31557600

export const planets = {
  mercury: 0.2408467,
  venus: 0.61519726,
  earth: 1,
  mars: 1.8808158,
  jupiter: 11.862615,
  saturn: 29.447498,
  uranus: 84.016846,
  neptune: 164.79132
} as const

export type Planet =  keyof typeof planets;

export function age(planet: Planet, seconds: number) {
  return Number(yearsToEarthYears(secondsToEarthYears(seconds), planet).toFixed(2))
}

export function secondsToEarthYears(seconds: number): number {
  return seconds/SECONDS_EARTH_YEAR
}

export function yearsToEarthYears (years: number, planet: Planet): number {
  return years/planets[planet] 
}
