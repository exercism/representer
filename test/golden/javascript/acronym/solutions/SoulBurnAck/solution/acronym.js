export const parse = words =>
  words
    .toUpperCase()
    .match(/[A-Z']+/g)
    .map(word => word[0])
    .join('');
