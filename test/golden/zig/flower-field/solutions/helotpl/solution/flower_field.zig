const std = @import("std");
const mem = std.mem;

pub fn annotate(allocator: mem.Allocator, garden: []const []const u8) mem.Allocator.Error![][]u8 {
    var prepare = try std.ArrayListUnmanaged([]u8).initCapacity(allocator, garden.len);
    defer {
        for (prepare.items) |item| {
            allocator.free(item);
        }
        prepare.deinit(allocator);
    }

    for (0..garden.len) |i| {
        const tmp = try allocator.alloc(u8, garden[i].len);
        @memcpy(tmp, garden[i]);
        try prepare.append(allocator, tmp);
    }

    const ret = try prepare.toOwnedSlice(allocator);

    const movesx = [_]isize{ -1, 0, 1, -1, 1, -1, 0, 1 };
    const movesy = [_]isize{ -1, -1, -1, 0, 0, 1, 1, 1 };

    for (ret, 0..) |row, y| {
        for (row, 0..) |cel, x| {
            if (cel == '*') continue;
            for (movesx, movesy) |movex, movey| {
                if (moveChecked(x, y, movex, movey, row.len, ret.len)) |pos| {
                    if (ret[pos.@"1"][pos.@"0"] == '*') ret[y][x] = gardenInc(ret[y][x]);
                }
            }
        }
    }

    return ret;
}

fn gardenInc(current: u8) u8 {
    return switch (current) {
        '1'...'8' => current + 1,
        ' ' => '1',
        else => '?',
    };
}

fn moveChecked(cx: usize, cy: usize, movex: isize, movey: isize, lenx: usize, leny: usize) ?struct { usize, usize } {
    var x = cx;
    var y = cy;
    if (movex < 0 and x == 0) return null;
    if (movey < 0 and y == 0) return null;
    if (movex > 0 and x + 1 >= lenx) return null;
    if (movey > 0 and y + 1 >= leny) return null;
    if (movex < 0) x -|= @intCast(-movex) else x +|= @intCast(movex);
    if (movey < 0) y -|= @intCast(-movey) else y +|= @intCast(movey);
    return .{ x, y };
}
