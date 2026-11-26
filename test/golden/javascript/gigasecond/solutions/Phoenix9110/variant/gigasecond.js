//
// This is only a SKELETON file for the 'Gigasecond' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const gigasecond = (inputDate) => {
  const finalDate = new Date()
  const GIGA_SECOND =  Math.pow(10, 9)
  finalDate.setTime(inputDate.getTime() + GIGA_SECOND/1000); //1Gsec * 1000milisec   
  return finalDate  
};
