export function isLeap(year: number) {
  if (year % 4) return false;
  if (year % 100) return true;
  if (year % 400) return false;
  return true;
}
