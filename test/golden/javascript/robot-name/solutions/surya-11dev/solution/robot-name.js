
const LENGTH_OF_ALPHABET = 26;
const FIRST_ASCII = 'A'.charCodeAt(0);

const generateAlphaCombos = (length, combo = '') => length
  ? [...Array(LENGTH_OF_ALPHABET).keys()]
    .flatMap(i => generateAlphaCombos(length - 1, combo + String.fromCharCode(i + FIRST_ASCII)))
  : combo;
const generateNumericalCombos = length => [...Array(10 ** length).keys()].map(num => `${num}`.padStart(length, '0'));
const generatePossibleNames = (alphaLength, numLength) => generateAlphaCombos(alphaLength)
  .flatMap(alphaCombo => generateNumericalCombos(numLength).map(numCombo => alphaCombo + numCombo));
// Randomly shuffle list of all possible names using Fisher-Yates
const shuffleNames = ([...names]) => names.reduce((shuffled, _, first) => {
  const second = Math.floor(Math.random() * first);
  [shuffled[first], shuffled[second]] = [shuffled[second], shuffled[first]];
  return shuffled;
}, names);
export class Robot {
  static ALPHABETICALS_LENGTH = 2;
  static NUMERICALS_LENGTH = 3;
  static POSSIBLE_NAMES = generatePossibleNames(Robot.ALPHABETICALS_LENGTH, Robot.NUMERICALS_LENGTH);
  static ELIGIBLE_NAMES = shuffleNames(Robot.POSSIBLE_NAMES);
  static releaseNames() {
    Robot.ELIGIBLE_NAMES = shuffleNames(Robot.POSSIBLE_NAMES);
  }
  #name
  constructor() {
    this.reset();
  }
  get name() {
    return this.#name;
  }
  reset() {
    this.#name = Robot.ELIGIBLE_NAMES.pop();
  }
}
