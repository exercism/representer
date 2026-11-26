const planets: { [key:string] : number } = {
  earth: 1.0,
  mercury: 0.2408467,
  venus: 0.61519726,
  mars: 1.8808158,
  jupiter: 11.862615,
  saturn: 29.447498,
  uranus: 84.016846,
  neptune: 164.79132
}

const earthYearInSeconds:number = 31557600

export function age(planet: string, seconds: number): number {
  const result = (seconds/earthYearInSeconds)/planets[planet]
  
  return parseFloat(result.toFixed(2)) 
}
