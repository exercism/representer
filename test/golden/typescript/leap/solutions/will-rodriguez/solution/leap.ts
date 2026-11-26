export function isLeap(year: number): boolean {
  const isDivisible = (factor: number): boolean => {
    return (year % factor) === 0 ? true : false;
  };

  if (isDivisible(100) && ! isDivisible(400)) {
    return false;
  }

  if (isDivisible(4)) {
    return true;
  }

  return false;
}
