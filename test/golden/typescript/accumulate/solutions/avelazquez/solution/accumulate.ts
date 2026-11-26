export function accumulate<T>(list: T[], accumulator: (value: T) => T): T[] {
  return list.map(accumulator);
}

//Other solution without map
/* export function accumulate<Type>(list: Type[], accumulator: Function): Type[] {
  const result: Type[] = [];
  for (let index = 0; index < list.length; index++) {
    result.push(accumulator(list[index]));
  }
  return result;
} */