export function score(scrab: string): number {
  let sum: number = 0;
  const vals: {[key: string]: number} = {
    A: 1,
    E: 1,
    I: 1,
    O: 1,
    U: 1,
    L: 1,
    N:1,
    R: 1,
    S: 1,
    T: 1,
    D: 2,
    G: 2,
    B : 3,
    C: 3,
    M: 3,
    P: 3,
    F: 4,
    H: 4,
    V: 4,
    W: 4,
    Y: 4,
    K: 5,
    J: 8,
    X: 8,
    Q: 10,
    Z: 10,
  }
  let tempVals: {[key: string] : number} = {}

  if (scrab === undefined) return 0;

  scrab
  .toUpperCase()
  .split("").forEach((char) => tempVals[char] = numOfOcc(scrab, char))

  for(let key in tempVals){
    sum += tempVals[key] * vals[key]
  }

  return sum;
}

const numOfOcc = (str: string, key: string): number => {
  let tempArr = str.split("");
  return tempArr.reduce(
    (acc, char) => (char.toUpperCase() === key.toUpperCase() ? acc + 1 : acc),
    0
  );
};