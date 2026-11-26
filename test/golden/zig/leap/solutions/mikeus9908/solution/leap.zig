pub fn isLeapYear(year: u32) bool {
    // if it can be divided by 400 can be divided both by 4 and 100
    if (year % 400 == 0)
        return true;

    // last condition is all years divided by four NOT divisible by 100

    if (year % 4 == 0 and year % 100 != 0)
        return true;

    // return false in any other case
    return false;
}
