//
// This is only a SKELETON file for the 'Rotational Cipher' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

const shiftLetters = (chi, per, key) => 
  String.fromCharCode((chi.charCodeAt(0) - per + key) % 26 + per)

export const rotate = (msg, key) => 
    msg.replace (/[a-z]/g, chiper => shiftLetters (chiper, 'a'.charCodeAt(0), key)).replace (/[A-Z]/g, chiper => shiftLetters (chiper, 'A'.charCodeAt(0), key))
