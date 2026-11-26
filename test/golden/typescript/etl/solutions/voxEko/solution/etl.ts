export function transform( scoreMappedToLetters: {[key: number]: string[]} ): {[key: string]: number} {
  let letterMappedToScore: {[key: string]: number} = {};
  
  for (const entry of Object.entries(scoreMappedToLetters)) {
    const score: number = Number(entry[0]);
    const letters: string[] = entry[1];
    letters.forEach(letter => {
      letterMappedToScore[letter.toLowerCase()] = score; 
    })
  }
  return letterMappedToScore;
}