function generateAlphabet(): string[] {
  const firstLetterCode = 97;
  const lastLetterCode = 122;
  const alphabet: string[] = [];
  for (let i = firstLetterCode; i <= lastLetterCode; i++) {
    const letter = String.fromCharCode(i);
    alphabet.push(letter);
  }
  return alphabet;
}

export function isPangram(string: string): boolean {
  const cleanedString = string.toLowerCase().replace(/[^a-z]+/g, "");
  const alphabet = generateAlphabet();
  const pangram: boolean = alphabet.every(letter => cleanedString.includes(letter));
  return pangram;
}
