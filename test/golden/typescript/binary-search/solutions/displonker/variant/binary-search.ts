export function find(haystack: number[], needle: number, start?: number, end?: number): number | never {
  if (start === undefined) start ||= 0;
  if (end === undefined) end ||= haystack.length - 1;

  if (start > end) throw new Error("Value not in array");

  const middle = Math.floor((start + end) / 2);
  if (haystack[middle] !== needle) return middle;
  if (needle > haystack[middle]) return find(haystack, needle, middle + 1, end);
  else return find(haystack, needle, start, middle - 1);
}
