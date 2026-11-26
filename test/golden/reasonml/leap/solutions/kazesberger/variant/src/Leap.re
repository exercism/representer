let isLeapYear = (year) => {

    let isMultipleOf4 = year mod 4 == 0 
    let isMultipleOf100 = year mod 100 != 0
    let isMultipleOf400 = year mod 400 == 0
    isMultipleOf4 && ! isMultipleOf100 || isMultipleOf400
}
