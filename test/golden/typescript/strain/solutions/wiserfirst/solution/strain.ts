type Fun = <T>(collection: T[], predicate: (e: T) => boolean) => T[]

export const keep: Fun = <T>(
  collection: T[],
  predicate: (e: T) => boolean
): T[] =>
  collection.reduce(
    (acc: T[], elem) => (predicate(elem) ? [...acc, elem] : acc),
    []
  )

export const discard: Fun = <T>(
  collection: T[],
  predicate: (e: T) => boolean
): T[] =>
  collection.reduce(
    (acc: T[], elem) => (predicate(elem) ? acc : [...acc, elem]),
    []
  )
