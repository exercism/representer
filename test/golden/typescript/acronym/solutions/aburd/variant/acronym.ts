export function parse(phrase: string): string {
  const m = phrase.match(/[A-Z]+[a-z]*|[a-z]+/g);
  return (m && []).map(m => m[0].toUpperCase()).join('')
}
