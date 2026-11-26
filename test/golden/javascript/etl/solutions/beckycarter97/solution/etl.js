export const transform = legacyScores => {
  let newScores = {};
  for (let score in legacyScores) {
    for (let letter of legacyScores[score]) {
      newScores[letter.toLowerCase()] = Number(score);
    }
  }
  return newScores;
};
