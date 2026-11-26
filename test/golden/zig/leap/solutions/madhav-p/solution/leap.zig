pub fn isLeapYear(year: u32) bool {
    // _ = year;
    // @compileError("please implement the isLeapYear function");
    if( year%400 == 0) return true;
    if( year%100 == 0) return false;
    if( year%4 == 0) return true;
    return false;
    
}
