//
// This is only a SKELETON file for the 'Anagram' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const findAnagrams = (string, array) => {
  let aux = string.toLowerCase();
let auxarray = toArray(aux);
auxarray.sort()
let anagrams = [];
let includesall = false;
for (let index = 0; index < array.length; index++) {
    if (array[index].length === aux.length) {
    
        let word = array[index];
        let wordarray = toArray(word.toLowerCase());
        wordarray.sort();
        if (word.toLowerCase() != aux) {
           for (let i = 0; i < wordarray.length; i++) {
            if (wordarray[i]!==auxarray[i]) {
                includesall = true;;
            } else {
                includesall = false;
                break;  
            }
            
           }
           if (includesall) {
        anagrams.push(array[index]);
        }
    }
    }
}
function toArray(string) {
    let array = [];
  for (let i = 0; i < string.length; i++) {
    array.push(string.charAt(i));    
  } 
  return array; 
}

    return anagrams;
};
