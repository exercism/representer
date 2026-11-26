pub fn total(basket: []const u32) u32 {
    var book_counts = [_]u32{0} ** 6;
    for (basket) |book| {
        book_counts[book] += 1;
    }
    std.mem.sort(u32, &book_counts, {}, std.sort.desc(u32));

    var bundle_counts = [_]u32{0} ** 5;
    for (&bundle_counts, 0..) |*b, i| {
        b.* = book_counts[i] - book_counts[i + 1];
    }

    const n = @min(bundle_counts[2], bundle_counts[4]);
    bundle_counts[2] -= n;
    bundle_counts[4] -= n;
    bundle_counts[3] += 2 * n;

    var sum: u32 = 0;
    for (bundle_counts, 1..) |count, size| {
        sum += count * price(size);
    }
    return sum;
}

fn price(bundleSize: usize) u32 {
    const basePrice: u32 = @intCast(bundleSize * 800);
    return switch (bundleSize) {
        1 => basePrice,
        2 => basePrice * 95 / 100,
        3 => basePrice * 90 / 100,
        4 => basePrice * 80 * 100,
        5 => basePrice * 75 / 100,
        else => unreachable,
    };
}

const std = @import("std");
