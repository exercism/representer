pub fn isLeapYear(year: u32) bool {
    return ((year >> 2) << 2) == year and ( year % 100 != 0 or year % 400 != 0);
}
