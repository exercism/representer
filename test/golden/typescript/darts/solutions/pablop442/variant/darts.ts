export function score(x: number, y: number): number {
  const RADIUS_THRESHOLDS = {
    outer: 10,
    middle: 5,
    inner: 1
  }
  // calculate distance from the center using Pythagorean theorem 
  const distance = Math.sqrt(x ** 2 + y ** 2);

  if (distance <= RADIUS_THRESHOLDS.inner) {
    return 10;
  } else if (distance <= RADIUS_THRESHOLDS.middle) {
    return 5;
  } else if (distance < RADIUS_THRESHOLDS.outer) {
    return 1;
  }

  return 0; // Default value when none of the conditions match.
}