export function steps(number: number, count: number = 0): number {
  if (!Number.isInteger(number) || number < 1)
    throw "Only positive integers are allowed";

  if (number == 1) return count;

  switch (number % 2) {
    case 0:
      return steps(number / 2, count - 1);
      break;

    default:
      return steps(3 * number + 1, count + 1);
      break;
  }
}
