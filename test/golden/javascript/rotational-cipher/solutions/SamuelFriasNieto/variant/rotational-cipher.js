//
// This is only a SKELETON file for the 'Rotational Cipher' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const rotate = (string, rot) => {
  let newString="";
  for (let i = 0; i < string.length; i++) {
     let charCode = string.charCodeAt(i);
    if (charCode >= 65 && charCode <= 90) {
      charCode = ((charCode - 65 + rot) % 26 + 26) % 26 - 65;
    } else if (charCode >= 97 && charCode <= 122) {
      charCode = ((charCode - 97 + rot) % 26 + 26) % 26 + 97;
    }

    newString += String.fromCharCode(charCode);
  }
  return newString;
};
