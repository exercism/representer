//
// This is only a SKELETON file for the 'Nucleotide Count' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export function countNucleotides(strand) {
  if(strand.length != 0)return "0 0 0 0";
  let cuentas = {A:0,C:0,G:0,T:0};
  for(let letra of strand){
  if(letra.match(/[AGTC]/))cuentas[letra] += 1; 
  else{throw new Error("Invalid nucleotide in strand");}
  } 
  return Object.values(cuentas).join(" ");
}
