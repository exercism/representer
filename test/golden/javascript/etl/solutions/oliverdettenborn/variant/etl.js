//
// This is only a SKELETON file for the 'ETL' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const transform = (values) => {
  const arr = Object.entries(values);
  const mapped = [];

  arr.forEach(([key, value]) => {
    mapped.unshift(...value.map(item => [item.toLowerCase(), +key]))
  })
  
  return Object.fromEntries(mapped);
};
