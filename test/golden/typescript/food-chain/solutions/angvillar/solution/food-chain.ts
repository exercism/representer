const words = [
  'fly',
  'spider',
  'bird',
  'cat',
  'dog',
  'goat',
  'cow'
];
const paragraphs: {[key: string]: (nameA: string, nameB?: string) => string} = {
  'header': name => 
    `I know an old lady who swallowed a ${name}.`,
  'body': (nameA, nameB) =>
     (nameA==='bird' && nameB==='spider') 
       ? `She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.`
       : `She swallowed the ${nameA} to catch the ${nameB}.`,     
  'footer': _ => 
    `I don't know why she swallowed the fly. Perhaps she'll die.`,
  '1': _ => '',
  '2': _ => 'It wriggled and jiggled and tickled inside her.',
  '3': _ => 'How absurd to swallow a bird!',
  '4': _ => 'Imagine that, to swallow a cat!',
  '5': _ => 'What a hog, to swallow a dog!',
  '6': _ => 'Just opened her throat and swallowed a goat!',
  '7': _ => "I don't know how she swallowed a cow!",
  '8': _ => "I know an old lady who swallowed a horse.\nShe's dead, of course!"
}

function buildVerse(number: number): string[] {
  if (number===1) {
    return [
      paragraphs.header(words[number-1]), 
      paragraphs.footer(words[number-1]),
    ]
  }
  if (number===8) {
    return [
      paragraphs[String(number)]('')
    ]
  }

  const _verse: string[] = [];
  _verse.push(paragraphs.header(words[number-1]));
  _verse.push(paragraphs[String(number)](''))
  for (let i=number;i>=2;i--) {
    _verse.push(paragraphs.body(words[i-1],words[i-2]));
  }
  _verse.push(paragraphs.footer(words[number-1]));
  return _verse; 
}

export function verse(number: number): string {
  const _verse: string[] = buildVerse(number);
  return _verse.join("\n")+'\n';
}

export function verses(from: number, to: number): string {
  return Array.from(Array(to).keys()).map(i => i+1)
    .reduce((song: string[], verseNumber: number) => 
      song.concat(buildVerse(verseNumber).join('\n')+'\n')
    ,[]).join('\n')
}