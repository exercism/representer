// Can be div by 4
// Cannot be div by 100
// Unless it Can also be div by 400


let  isLeapYear = (year) => {
(year mod 4 == 0 && year mod 100 == 0 && year mod 400 == 0) || (year mod 4 == 0 && year mod 100 > 0)
};