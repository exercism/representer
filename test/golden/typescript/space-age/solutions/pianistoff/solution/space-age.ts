const EARTH_YEAR_SECONDS = 31_557_600;

const RATIOS = {
  earth: 1,
  mercury: 0.2408467,
  venus: 0.61519726,
  mars: 1.8808158,
  jupiter: 11.862615,
  saturn: 29.447498,
  uranus: 84.016846,
  neptune: 164.79132,
} as const;

type Planet = keyof typeof RATIOS;

/**
 * Converts an age provided in seconds into the age in years of a particular planet.
 * @param {Planet} planet A name of the planet to be calculated years in.
 * @param {number} seconds An age in seconds.
 * @returns {number} The age in years of a specified planet.
 */
export const age = (planet: Planet, seconds: number): number => {
  return (
    Math.round((seconds / (EARTH_YEAR_SECONDS * RATIOS[planet])) * 100) / 100
  );
};
