const std = @import("std");
const assert = std.debug.assert;

pub const Classification = enum {
    deficient,
    perfect,
    abundant,
};

/// Asserts that `n` is nonzero.
pub fn classify(n: u64) Classification {
    assert(n > 0);
    
    var sum: u128 = 0;
    var i: u64 = 1;
    while (true) : (i += 1) {
        if (i * i > n) 
            break;
        
        if (i * i == n) {
            sum += i;
        }
        else {
            if (n % i == 0)
                sum += i + n / i;
        }
    }
    sum -= n;

    if (sum == n) return Classification.perfect;
    return if (sum > n) Classification.abundant else Classification.deficient;
}
