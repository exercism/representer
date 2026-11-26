const EARTH_YEAR_SECONDS = 31557600;

type Planet = |
    'mercury' |
    'venus'   | 
    'earth'   | 
    'mars'    | 
    'jupiter' | 
    'saturn'  | 
    'uranus'  | 
    'neptune';

export function age(planet: Planet, seconds: number): number {
  let age: number;
  
  switch(planet) {
    case 'mercury': 
      age = seconds / (EARTH_YEAR_SECONDS * 0.2408467);
      break;
    case 'venus': 
      age = seconds / (EARTH_YEAR_SECONDS * 0.61519726);
      break;
    case 'earth': 
      age = seconds / EARTH_YEAR_SECONDS;
      break;
    case 'mars': 
      age = seconds / (EARTH_YEAR_SECONDS * 1.8808158);
      break;
    case 'jupiter': 
      age = seconds / (EARTH_YEAR_SECONDS * 11.862615);
      break;
    case 'saturn': 
      age = seconds / (EARTH_YEAR_SECONDS * 29.447498);
      break;
    case 'uranus': 
      age = seconds / (EARTH_YEAR_SECONDS * 84.016846);
      break;
    case 'neptune':
      age = seconds / (EARTH_YEAR_SECONDS * 164.79132);
      break;
  }

  return Number(age.toFixed(2));
}
