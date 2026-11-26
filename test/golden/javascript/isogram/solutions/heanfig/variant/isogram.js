//
// This is only a SKELETON file for the 'Isogram' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const isIsogram = w => [...w.replace(/[\s-_]/g,'')]
.every(e=>(w.match(RegExp(`${e}`,'gi'))||[]).length!=1);