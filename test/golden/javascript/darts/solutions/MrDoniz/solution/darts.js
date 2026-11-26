/**
 * Universidad de La Laguna
 * Escuela Superior de Ingeniería y Tecnología
 * Grado en Ingeniería Informática
 * Programación de Aplicaciones Interactivas
 *
 * @author Daniel Dóniz García
 * @since Mar 11 2022
 * @desc Isbn Verifier 
 *       Write a function that returns the earned points in a single toss of a
 *       Darts game.Darts is a game where players throw darts to a target.Write
 *       a function that given a point in the target (defined by its real
 *       cartesian coordinates x and y), returns the correct amount earned by a
 *       dart landing in that point.
 * @see {@link https://exercism.org/tracks/javascript/exercises/darts}
 * @see {@link https://mathieularose.com/main-function-in-node-js}
 *
 */


/**
 * @description
 * @param {Number} number - Number to be checked
 * @returns 
 */
export const score = (x = 0, y = 0) => {
  const coord = x ** 2 + y ** 2;
  return coord > 100 ? 0 : coord > 25 ? 1 : coord > 1 ? 5 : 10;
};
