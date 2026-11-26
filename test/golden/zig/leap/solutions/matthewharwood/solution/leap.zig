pub fn isLeapYear(year: u32) bool {
    const divisibleBy4 = year % 4 == 0;
    const divisibleBy100 = year % 100 == 0;
    const divisibleBy400 = year % 400 == 0;
    
    return divisibleBy4 and (!divisibleBy100 or divisibleBy400);
}
