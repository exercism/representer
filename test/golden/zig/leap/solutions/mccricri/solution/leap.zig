const math = @import("std").math;

pub fn isLeapYear(year: u32) bool {
    
    const m = @mod(year,4);
    if(m != 0) return false;

    const cent = @mod(year,100);
    if(cent == 0 ){
       const qc = @mod(year,400);
       if(qc == 0) return true;
       return false;
    } 
    
    return true;
}
