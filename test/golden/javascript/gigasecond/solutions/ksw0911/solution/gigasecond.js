//
// This is only a SKELETON file for the 'Gigasecond' exercise. It's been provided as a
// convenience to get you started writing code faster.
//
var gs= 1e12
export const gigasecond = (date) => {
   var data = new Date(date.getTime()+gs); 
   
  return data;
};
