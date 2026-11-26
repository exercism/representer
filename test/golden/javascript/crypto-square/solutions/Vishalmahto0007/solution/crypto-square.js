//
// This is only a SKELETON file for the 'Crypto Square' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export class Crypto {
  constructor(text) {
    this.orig = text;
    this.plain = text.trim().toLowerCase().replace(/\W/g, '');
    // throw new Error('Remove this statement and implement this function');
  }

  get ciphertext() {
    let L = Math.sqrt(this.plain.length);
    let R = Math.round(L, 0);
    let C = Math.ceil(L);
    let P = this.plain.padEnd(R * C, ' ');

    return [...Array(C)].map((_,i)=> [...P].filter((_,pi)=> pi % C === i).join('')).join(' ');
    // throw new Error('Remove this statement and implement this function');
  }
}
