const a = 'a'.charCodeAt(0);
const z = a + 25;
const zero = '0'.charCodeAt(0);
const nine = zero + 9;

export function encode(plainText: string): string {
  let result = '';
  let len = 0;
  for (const char of plainText.toLowerCase()) {
      const c = char.charCodeAt(0);
      if (a <= c && c <= z) {
        if (len > 0 && len % 5 === 0) {
          result += ' ';
        }
        len++;
        result += String.fromCharCode(z - (c - a));
      } else if (zero < c && c <= nine) {
        if (len > 0 && len % 5 === 0) {
          result += ' ';
        }
        len++;
        result += char; 
      }
  }
  return result;
}

export function decode(cipherText: string): string {
  let result = '';

  for (const char of cipherText) {
    if (char === ' ') continue;
    const c = char.charCodeAt(0);
    if (zero <= c && c <= nine) {
      result += char;
    } else {
      result += String.fromCharCode(a + z - c)
    }
  }

  return result;
}
