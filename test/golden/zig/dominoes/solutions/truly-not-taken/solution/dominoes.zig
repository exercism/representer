pub fn canChain(_: std.mem.Allocator, stones: []const [2]u3) error{}!bool {
    if (stones.len == 0) return true;
    if (stones.len == 1) return stones[0][0] == stones[0][1];

    var halves: [7]usize = @splat(0);
    var count: [7][7]usize = @splat(@splat(0));
    for (stones) |stone| {
        count[stone[0]][stone[1]] += 1;
        count[stone[1]][stone[0]] += 1;
        halves[stone[0]] += 1;
        halves[stone[1]] += 1;
    }
    const V = @Vector(7, usize);
    // loose end
    if (@reduce(.Or, @as(V, halves)) & 1 == 1) return false;
    const all: u8 = @as(u7, @bitCast(@as(V, halves) != @as(V, @splat(0))));
    var chain: u8 = 0;
    // pick any half-stone
    var connected: u8 = @as(u8, 1) << @intCast(@ctz(all));
    // add to the chain anything that is connected to that stone
    while (connected != chain) {
        chain = connected;
        for (0..7) |i| {
            if (@as(u8, 1) << @intCast(i) & connected == 0) continue;
            connected |= @as(u7, @bitCast(@as(V, count[i]) != @as(V, @splat(0))));
        }
    }
    return chain == all;
}

test canChain {
    const expect = std.testing.expect;
    try expect(try canChain(undefined, &.{ .{ 2, 1 }, .{ 2, 3 }, .{ 1, 3 } }));
    try expect(!try canChain(undefined, &.{ .{ 1, 2 }, .{ 4, 1 }, .{ 2, 3 } }));
}

test "fuzzer found one loop" {
    try std.testing.expect(try canChain(undefined, &.{
        .{ 1, 6 },
        .{ 6, 1 },
        .{ 1, 6 },
        .{ 1, 6 },
        .{ 1, 1 },
    }));
}

test "fuzzer found more than one pass to connect all" {
    try std.testing.expect(try canChain(undefined, &.{
        .{ 0, 1 },
        .{ 6, 1 },
        .{ 4, 3 },
        .{ 1, 2 },
        .{ 6, 4 },
        .{ 1, 0 },
        .{ 6, 4 },
        .{ 3, 4 },
        .{ 2, 6 },
    }));
}

test "fuzzer found a flawed optimization" {
    try std.testing.expect(try canChain(undefined, &.{ .{ 4, 4 }, .{ 4, 4 } }));
}

fn root(parents: []usize, element: usize) usize {
    var current = element;
    var parent = parents[current];
    while (parent != current) {
        const grandparent = parents[parent];
        parents[current] = grandparent;
        current = parent;
        parent = grandparent;
    }
    return current;
}

pub fn oracle(allocator: std.mem.Allocator, stones: []const [2]u3) std.mem.Allocator.Error!bool {
    _ = allocator;

    var tally = std.mem.zeroes([8]usize);
    var parents = [8]usize{ 0, 1, 2, 3, 4, 5, 6, 7 };
    for (stones) |stone| {
        tally[stone[0]] += 1;
        tally[stone[1]] += 1;

        const first = root(&parents, stone[0]);
        const second = root(&parents, stone[1]);
        parents[second] = first;
    }

    var roots: usize = 0;
    for (0..8) |i| {
        if ((tally[i] & 1) != 0) {
            return false;
        }
        if (tally[i] != 0 and parents[i] == i) {
            roots += 1;
        }
    }
    return roots <= 1;
}

test "fuzzing is fun" {
    try std.testing.fuzz({}, testOne, .{
        .corpus = &.{
            //~ @embedFile("crash"),
        },
    });
}

fn testOne(_: void, smith: *std.testing.Smith) !void {
    var buffer: [100][2]u3 = undefined;
    const stones = buffer[0..smith.valueRangeAtMost(u32, 0, buffer.len)];
    for (stones) |*stone| smith.bytesWeighted(@ptrCast(stone), &.{.rangeAtMost(u3, 0, 6, 1)});
    errdefer std.log.err("{any}", .{stones});
    const expected = try oracle(undefined, stones);
    errdefer std.debug.print(
        \\
        \\test "fuzzer found" {{
        \\    try std.testing.expect({s}try canChain(undefined, &{f}));
        \\}}
        \\
    ,
        .{ if (expected) "" else "!", std.zon.fmt(stones, .{}) },
    );
    try std.testing.expectEqual(expected, canChain(undefined, stones));
}

const std = @import("std");

