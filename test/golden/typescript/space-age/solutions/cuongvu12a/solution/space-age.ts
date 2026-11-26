export function age(planet: typeof list[number], seconds: number): number {
  return (
    Math.round((seconds / orbitalPeriod[planet] / secondOfTheYear) * 100) /
    100
  );
}
const secondOfTheYear = 31557600;
const orbitalPeriod: Record<typeof list[number], number> = {
  mercury: 0.2408467,
  venus: 0.61519726,
  earth: 1,
  mars: 1.8808158,
  jupiter: 11.862615,
  saturn: 29.447498,
  uranus: 84.016846,
  neptune: 164.79132,
};
const list = [
  'mercury',
  'venus',
  'earth',
  'mars',
  'jupiter',
  'saturn',
  'uranus',
  'neptune',
];