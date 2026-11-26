
export const transform = (oldScoringTable) => {
  let newScoringTable = {};
  for (let score in oldScoringTable) {
    for (let letter of oldScoringTable[score]) {
      newScoringTable[letter.toLowerCase()] = Number(score);
    }
  }
  return newScoringTable;
};
