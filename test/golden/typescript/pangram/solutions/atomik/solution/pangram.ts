export function isPangram(phrase: string): boolean {
  if(phrase === '') {
    return false
  }
  const alphabet =["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
  const sanitizedPhraseArray = phrase.toLowerCase().replace(' ','').split('');
  return alphabet.filter(element => sanitizedPhraseArray.indexOf(element) < 0).length === 0
}
