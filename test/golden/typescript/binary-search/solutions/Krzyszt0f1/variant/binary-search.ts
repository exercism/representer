export function find(haystack: number[], needle: number): number | never {
  let left: number = 0;
  let right: number = haystack.length - 1;
  let middleElementPosition: number = 0;

  while(left <= right) {
    middleElementPosition = Math.floor((left + right) / 2);
    console.log(middleElementPosition);

    if (haystack[middleElementPosition] < needle) {
      left = middleElementPosition + 1;
    } else if (haystack[middleElementPosition] > needle) {
      right = middleElementPosition + 1;
    } else {
      return middleElementPosition;
    };
  };
  throw new Error("Value not in array");
}
