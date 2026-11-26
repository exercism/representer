export const transform = (oldObject) => {
  let newObject = {};
  for (let score in oldObject) {
    for (let letter of oldObject[score]) {
      newObject[letter.toLowerCase()] = Number(score);
    }
  }
  return newObject;
};
