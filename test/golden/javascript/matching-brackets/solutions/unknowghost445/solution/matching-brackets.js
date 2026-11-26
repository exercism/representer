//
// This is only a SKELETON file for the 'Matching Brackets' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const isPaired = (str) => {
  const MAP = {
    '[': ']',
    '{': '}',
    '(': ')',
  };
  str = str.replace(/[^(){}\[\]]/g, '');
  const list = [];
  for(const b of str) {
    if(MAP[b])
      list.push(b);
    else {
      if(list.length === 0)
        return false;
      if(MAP[list.pop()] !== b)
        return false;
    }
  }
  return list.length === 0;
};
