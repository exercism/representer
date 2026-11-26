const letterPointMap: Map<string, number> = new Map([
  ["AEIOULNRST", 1],
  ["DG", 2],
  ["BCMP", 3],
  ["FHVWY", 4],
  ["K", 5],
  ["JX", 8],
  ["QZ", 10],
]);

function calcPoints(character: string): number {
  for (let [letters, points] of letterPointMap) {
    if (letters.includes(character)) {
      return points;
    }
  }
  return 0;
}

export function score(word: string): number {
  if (typeof word !== "string") return 0;
  return word
    .toUpperCase()
    .split("")
    .map(calcPoints)
    .reduce((acc, points) => acc + points, 0);
}
