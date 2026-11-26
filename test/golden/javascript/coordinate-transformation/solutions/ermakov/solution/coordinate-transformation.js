// @ts-check

export function translate2d(dx, dy) {
  return function scale(x, y) {
    return [x + dx, y + dy];
  }
}

export function scale2d(sx, sy) {
  return (a, b) => [sx * a, sy * b];
}

export function composeTransform(f, g) {
  return (x, y) => {
    const fResult = f(x, y)
    return g(fResult[0], fResult[1]);
  };
}

/**
 * Return a function that memoizes the last result.  If the arguments are the same as the last call,
 * then memoized result returned.
 *
 * @param {function} f the transformation function to memoize, assumes takes two arguments 'x' and 'y'
 *
 * @returns {function} a function which takes x and y arguments, and will either return the saved result
 *  if the arguments are the same on subsequent calls, or compute a new result if they are different.
 */
export function memoizeTransform(f) {
  let savedX
  let savedY
  let savedResult
  return function (x, y) {
    if (x !== savedX || y !== savedY) {
      savedX = x;
      savedY = y;
      savedResult = f(x, y);
    }
    return savedResult;
  };
}
