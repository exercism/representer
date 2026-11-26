const offset: number = 'a'.charCodeAt(0);
const size: number = 26;

export class SimpleCipher {
  key: string;

  constructor(key: string | undefined = undefined) {
    this.key = key ?? this.randomKey();
  }
  
  encode(plainText: string): string {
    return this.shift(plainText);
  }

  decode(cipherText: string): string {
    return this.shift(cipherText, true);
  }

  private shift(text: string, reverse: boolean = false): string {
    return [...text].map((c, i) => {
      return this.shiftChar(c, this.key[i % this.key.length], reverse);
    }).join('');
  }

  private shiftChar(c: string, key: string, reverse: boolean): string {
    let posC = c.charCodeAt(0) - offset;
    let posKey = key.charCodeAt(0) - offset;
    let posResult = ((posC + (reverse ? -posKey : posKey)) + size) % size;
    return String.fromCharCode(offset + posResult);
  }

  private randomKey(length: number = 100): string {
    return Array.from({ length }, _ => {
      return String.fromCharCode(offset + Math.floor(Math.random() * 26));
    }).join('');
  }
}
