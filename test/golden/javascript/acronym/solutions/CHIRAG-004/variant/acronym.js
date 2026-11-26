//
// This is only a SKELETON file for the 'Acronym' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const parse = (str) => {
  let newStr = str.replace(/[_-]/g, " ").replace(/[^\w\s]/g, "")
  console.log(newStr)
  let arr = newStr.match(/\b[a-z]/gi)
  console.log(arr)
  return arr.join("").toLowerCase()
};
