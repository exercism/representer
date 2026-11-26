export function isIsogram(phrase: string): boolean {
  if(phrase === '') return true;
  let arr: RegExpMatchArray = phrase.toLowerCase().match(/[a-z]/g)!;
  return !arr.some((elem, idx) => arr.includes(elem, idx + 1))
}
