// @ts-check

/**
 * 
 * @param {number[]} arr 
 * @param {number} num 
 * @returns {number}
 */
export const sum = (arr, num) => {
  /** @type {Set<number>} */
  let set = new Set();

  for(let elm of arr) {
    if(elm) {
      for (let i=elm; i<num; i+=elm) {
        set.add(i);
      }
    }
  }

  const result = Array.from(set).reduce((prev, cur) => cur + prev, 0);

  return result;
};
