//
// This is only a SKELETON file for the 'Say' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

const ALPHANUMBERS = {
  1: "one",
  2: "two",
  3: "three",
  4: "four",
  5: "five",
  6: "six",
  7: "seven",
  8: "eight",
  9: "nine",
  10: "ten",
  11: "eleven",
  12: "twelve",
  13: "thirteen",
  14: "fourteen",
  15: "fifteen",
  16: "sixteen",
  17: "seventeen",
  18: "eighteen",
  19: "nineteen",
  20: "twenty",
  30: "thirty",
  40: "forty",
  50: "fifty",
  60: "sixty",
  70: "seventy",
  80: "eighty",
  90: "ninety",
};



export const say = (n) => {
 let str = ""
  if(n == 0) return 'zero'
  if(n < 0 || n > 999999999999) throw new Error('Number must be between 0 and 999,999,999,999.')
 function makeItSay(n) {
    

  if(n < 20) return ALPHANUMBERS[n] || ''

   if(n < 100){
     //ten's
     let tens = Math.floor(n/10) * 10
     //below ten's
     let belowTens = n%10
     //join
     return ALPHANUMBERS[tens] + (belowTens ? "-" + ALPHANUMBERS[belowTens] : "")
   }

   if(n < 1000){
     //hundred's
     let hundreds = Math.floor(n/100)
     //belowHundred's
     let belowHundred = n%100

     return ALPHANUMBERS[hundreds] + " hundred" + (belowHundred ? " " + makeItSay(belowHundred) : '')
   }
}

  if(n >= 100000000){
    let billions = Math.floor(n/1000000000)
    n = n % 1000000000
    str += makeItSay(billions) + " billion"
    if(n) str += " "
  }

  if(n >= 100000){
     let millions = Math.floor(n/1000000)
    n = n % 1000000
    str += makeItSay(millions) + " million"
    if(n) str += " "
  }

  if(n >= 1000){
    let thousands = Math.floor(n/1000)
    n = n % 1000
    str += makeItSay(thousands) + " thousand"
    if(n) str += " "
  }
  
  str += makeItSay(n)
  
 return str
};
