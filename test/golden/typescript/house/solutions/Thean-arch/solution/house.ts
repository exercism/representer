const arr1: string[] = [
  '',
  "house that Jack built.",
  "malt",
  "rat",
  "cat",
  "dog",
  "cow with the crumpled horn",
  "maiden all forlorn",
  "man all tattered and torn",
  "priest all shaven and shorn",
  "rooster that crowed in the morn",
  "farmer sowing his corn",
  "horse and the hound and the horn"
];

const arr2: string[] = [
  '',
  "lay in",
  "ate",
  "killed",
  "worried",
  "tossed",
  "milked",
  "kissed",
  "married",
  "woke",
  "kept",
  "belonged to"
];




export function verse(n: number): string[] {
  const str: string =`This is the ${arr1[n]}`
  const temp: string[] = [str];
  for (let i = n-1; i > 0; i--) {
      temp.push(`that ${arr2[i]} the ${arr1[i]}`);
  }
  return temp;
}

export function verses(from: number, to: number): string[] {
  let v = [];
    for (let i = from; i <= to; i++) {
  v.push(...verse(i), '');
    }
  v.splice(-1);
  return v;
}
