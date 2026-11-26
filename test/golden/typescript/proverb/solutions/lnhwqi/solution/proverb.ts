export function proverb(...args: string[]) {
  return recursive(args, "", args[0]);
}
function recursive(arr: string[], result: string, first: string): string {
  const [current, second, ...rest] = arr;

  if (!second) {
    return result + `And all for the want of a ${first}.`;
  }

  const str = result + `For want of a ${current} the ${second} was lost.\n`;
  return recursive([second, ...rest], str, first);
}
