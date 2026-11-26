const alphabet: string[] = [
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 
  'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
]
const reversedAlphabet = [...alphabet].reverse();

interface Dictionary {
  [key:string]: string
}

const plainTextToCipherText : Dictionary = alphabet.reduce(
  (acc, val, idx) => Object.assign(acc, {[val]: reversedAlphabet[idx]}), {});
const cipherTextToPlainText : Dictionary = reversedAlphabet.reduce(
  (acc, val, idx) => Object.assign(acc, {[val]: alphabet[idx]}), {});

export function encode(plainText: string): string {
  return Array.from(plainText.toLowerCase()).reduce((acc, val) => {
    if (plainTextToCipherText[val]) {
      return acc.concat(plainTextToCipherText[val]);
    }
    if (val.match(/\d/)) {
      return acc.concat(val);
    }
    return acc;
  }, new Array<string>()).map((v, i) => i % 5 == 4 ? v + ' ' : v).join('').trim();
}

export function decode(cipherText: string): string {
  return Array.from(cipherText).reduce((acc, val) => {
    if (val === ' ') {
      return acc;
    } 
    if (val.match(/\d/)) {
      return acc + val;
    }
    return acc + cipherTextToPlainText[val]
  }, '');
}
