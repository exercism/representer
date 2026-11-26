export function transform(old: { [key: string]: string[] }): { [key: string]: number } {
  const newFormat: { [key: string]: number } = {};

  for (const [pointValue, letters] of Object.entries(old)) {
    letters.forEach(letter => {
      newFormat[letter.toUpperCase()] = parseInt(pointValue);
    });
  }

  return newFormat;
}
