// @ts-check

export const EXPECTED_MINUTES_IN_OVEN = 40;
const PREPARATION_MINUTES_PER_LAYER = 2;

export const remainingMinutesInOven = (/** @type {number} */ actualMinutes) =>
  EXPECTED_MINUTES_IN_OVEN - actualMinutes;

export const preparationTimeInMinutes = (/** @type {number} */ layersNum) =>
  layersNum * PREPARATION_MINUTES_PER_LAYER;

export const totalTimeInMinutes = (
  /** @type {number} */ numberOfLayers,
  /** @type {number} */ actualMinutesInOven
) => {
  return preparationTimeInMinutes(numberOfLayers) + actualMinutesInOven;
};
