pub fn isLeapYear(year: u32) bool {
    const byFour: bool = year % 4 == 0;
    const byHundred: bool = year % 100 == 0;
    const byFourHundred = year % 400 == 0;
    return byFour and (!byHundred or byFourHundred);
}
