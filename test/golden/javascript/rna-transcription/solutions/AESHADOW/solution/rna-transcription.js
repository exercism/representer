//
// This is only a SKELETON file for the 'RNA Transcription' exercise. It's been provided as a
// convenience to get you started writing code faster.
//
const transNuc = { 'G': 'C', 'C': 'G', 'A': 'U', 'T': 'A' };
export const toRna = DNA => [...DNA].map(nuc => transNuc[nuc]).join('');
