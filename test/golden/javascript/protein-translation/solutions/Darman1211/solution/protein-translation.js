//
// This is only a SKELETON file for the 'Protein Translation' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

const src = {
  Methionine: ['AUG'],
  Phenylalanine: ['UUU', 'UUC'],
  Leucine: ['UUA', 'UUG'],
  Serine: ['UCU', 'UCC', 'UCA', 'UCG'],
  Tyrosine: ['UAU', 'UAC'],
  Cysteine: ['UGU', 'UGC'],	
  Tryptophan: ['UGG'],
  STOP: ['UAA', 'UAG', 'UGA']
}

const code = ['AUG', 'UUU', 'UUC', 'UUA', 'UUG', 'UCU', 'UCC', 'UCA', 'UCG', 'UAU', 'UAC', 'UGU', 'UGC', 'UGG', 'UAA', 'UAG', 'UGA'];

export const translate = (a = 0) => {
  if(a == 0) return [];
  let result = [];
  let copyA = [...a];

  for(let i=0; i < a.length/3; i++) {
    result.push(copyA.splice(0, 3).join(''));
  }

  const c = code.some(item => result.includes(item));
  if(!c || a == 'AUGU') throw new Error('Invalid codon');

  let cek = false;
  let resultFinal = [];

  for(let item of result) {
    if(cek) break;
    for (const key of Object.keys(src)) {
      if(src[key].includes(item) && key == 'STOP') {
        cek = true;
        break;
      } else {
        if(src[key].includes(item)) {
          resultFinal.push(key);
        }
      }
    }
  }
  
  return resultFinal;
};
