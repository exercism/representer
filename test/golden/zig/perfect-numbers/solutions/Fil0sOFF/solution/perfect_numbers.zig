const std = @import("std");

pub const Classification = enum {
    deficient,
    perfect,
    abundant,
};

/// Asserts that `n` is nonzero.
pub fn classify(n: u64) Classification {
    if (n == 0) unreachable;
    var sum: usize = 0;
    for (1..n) |testfactor| {
        if (n % testfactor == 0)
            sum += testfactor;
    }

    if (sum > n) return Classification.abundant;
    if (sum < n) return Classification.deficient;
    return Classification.perfect;
}
