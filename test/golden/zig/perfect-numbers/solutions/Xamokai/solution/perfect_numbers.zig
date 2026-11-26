pub const Classification = enum {
    deficient,
    perfect,
    abundant,
};

/// Asserts that `n` is nonzero.
pub fn classify(comptime n: u64) Classification {
    var sum: u64 = 0;
    for(1..(n/2 + 1)) |i|{
        if(n % i == 0){
            sum += i;
        }
    }
    switch(sum) {
        0...(n-1) => return Classification.deficient,
        n => return Classification.perfect,
        else => return Classification.abundant, 
    }
}
