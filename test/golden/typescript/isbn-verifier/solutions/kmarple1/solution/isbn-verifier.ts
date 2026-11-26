export function isValid(isbn: string): boolean {
  let sum = 0, count = 10, nums = 0;

  for (let i = 0; i < isbn.length - 1; i++) {
    if (isbn[i] !== '-' && count > 0) {
      if (isbn[i] !== 'X') {
        sum += count * Number.parseFloat(isbn[i]);
      }
      nums++;
      count--;
    }
  }
  
  if (count > 1 || nums > 9) {
    return false;
  }

  
  const checkVal = isbn[isbn.length - 1];
  if (checkVal === 'X') {
    sum += 10
  } else {
    sum += Number.parseFloat(checkVal);
  }

  return sum % 11 === 0;
}
