export function isIsogram(word: string): boolean {
  const alphabetWord = word.toLowerCase().replace(/[^a-z]/, '')
  const uniqueLetters = new Set(alphabetWord.toLowerCase().split(''))
  return uniqueLetters.size === alphabetWord.length
}
