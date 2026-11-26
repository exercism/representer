export function isIsogram(phrase: string): boolean {
  const phraseLower = phrase.toLowerCase();
  return phraseLower.split("").every((char) => {
    if (/\w/.test(char)) {
      return phraseLower.match(new RegExp(char, "g"))?.length === 1;
    }
    return true;
  });
}
