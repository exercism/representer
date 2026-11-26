export class Cipher {

  constructor(key) {
    if (key || key === '') {
      if (this.checkKey(key) === false) {
        throw new Error('Bad key')
      }
    }

    this._key = key || this.generateRandomKey();
  }

  get key() {
    return this._key;
  }

  checkKey(key) {
    if (key === '') {
      return false;
    }
    for (let index = 0; index < key.length; index++) {
      if (!LETTERS.includes(key[index])) {
        return false;
      }
    }
  }

  generateRandomKey() {
    let key = '';
    for (let index = 0; index < 100; index++) {
      key += LETTERS[Math.floor(Math.random() * LETTERS.length)];
    }

    return key;
  }

  encode(phrase) {
    let encoded = '';

    while (this.key.length < phrase.length) {
      this._key += this._key;
    }

    for (let index = 0; index < phrase.length; index++) {
      let oldLetter = LETTERS.indexOf(phrase[index]);
      let shift = LETTERS.indexOf(this._key[index]);

      let newLetter = oldLetter - shift > LETTERS.length - 1 ? (oldLetter + shift) - LETTERS.length : oldLetter + shift;
      encoded += LETTERS[newLetter];
    }

    return encoded;
  }

  decode(phrase) {
    let decoded = '';

    while (this.key.length < phrase.length) {
      this._key += this._key;
    }

    for (let index = 0; index < phrase.length; index++) {
      let oldLetter = LETTERS.indexOf(phrase[index]);
      let shift = LETTERS.indexOf(this._key[index]);

      let newLetter = oldLetter - shift < 0 ? (oldLetter - shift) + LETTERS.length : oldLetter - shift;
      decoded += LETTERS[newLetter];
    }

    return decoded;
  }
}

const LETTERS = 'abcdefghijklmnopqrstuvwxyz'