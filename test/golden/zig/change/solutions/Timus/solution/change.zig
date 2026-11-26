const std = @import("std");

pub const ChangeError = error{
    NegativeTarget,
    UnreachableTarget,
};

pub fn findFewestCoins(
    allocator: std.mem.Allocator,
    coins: []const u64,
    target: i64,
) (std.mem.Allocator.Error || ChangeError)![]u64 {
    if (target < 0) return ChangeError.NegativeTarget;

    const n_coins: usize, const len: usize = .{ coins.len, @intCast(target + 1) };

    var ts = try allocator.alloc(?usize, len);
    defer allocator.free(ts);
    var cs = try allocator.alloc(usize, n_coins * len);
    defer allocator.free(cs);

    ts[0] = 0;
    @memset(cs[0..n_coins], 0);
    var i_cs = n_coins;
    for (1..len) |i_ts| {
        var count: ?usize, const counts = .{ null, cs[i_cs .. i_cs + n_coins] };
        var c = n_coins;
        while (c > 0) {
            c -= 1;
            const coin = coins[c];
            if (coin > i_ts) continue;
            const j: usize = @intCast(i_ts - coin);
            const j_count = ts[j] orelse continue;
            if (count != null and j_count + 1 >= count.?) continue;
            count = j_count + 1;
            @memcpy(counts, cs[j * n_coins .. (j + 1) * n_coins]);
            counts[c] += 1;
        }
        ts[i_ts] = count;
        i_cs += n_coins;
    }
    if (ts[len - 1]) |target_count| {
        var result = try allocator.alloc(u64, target_count);
        errdefer allocator.free(result);
        var i: usize = 0;
        for (cs[cs.len - n_coins ..], coins) |count, coin| {
            @memset(result[i .. i + count], coin);
            i += count;
        }
        return result;
    }
    return ChangeError.UnreachableTarget;
}
