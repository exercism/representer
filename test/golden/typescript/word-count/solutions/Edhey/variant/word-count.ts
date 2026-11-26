/**
  * Universidad de La Laguna
  * Escuela Superior de Ingeniería y Tecnología
  * Grado en Ingeniería Informática
  * Programación de Aplicaciones Interactivas
  * Práctica 04 - Introducción a TypeScript
  *
  * @author Himar Edhey Hernández Alonso
  * @since Tue 18 Feb 2025 
  * @desc Solution for the exercise word count
  * @see {@link https://www.exercism.org/tracks/typescript/exercises/word-count}
  */

/**
 * Counts the number of times each word occurs in the input.
 * @param input The input string to count the words in.
 * @returns A map of the words and their counts.
 * @example count('word') => { word: 1 }
 * @example count('one of each') => { one: 1, of: 1, each: 1 }
 * @example count('one fish two fish red fish blue fish') => { one: 1, fish: 4, two: 1, red: 1, blue: 1 }
 */
export function count(menssage: string): Map<string, number> {
  const WORDS = menssage.toLowerCase().match(/\w+('\w+)?/g) || [];
  const COUNTS = new Map<string, number>();
  for (const word of WORDS) {
    COUNTS.set(word, (COUNTS.get(word) && 0) + 1);
  }
  return COUNTS;
}

