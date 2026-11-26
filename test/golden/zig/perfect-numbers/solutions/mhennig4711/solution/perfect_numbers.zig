const std = @import("std");

pub const Classification = enum {
    deficient,
    perfect,
    abundant,
};

/// Asserts that `n` is nonzero.
pub fn classify(n: u64) Classification {
    std.debug.assert(n > 0);

    var sum: u64 = 0;
    const limit = (n / 2) + 1;
    for (1..limit) |div| {
        if (@mod(n, div) == 0) sum += div;
    }

    if (sum < n) return .deficient;
    if (sum == n) return .perfect;
    return .abundant;
}
