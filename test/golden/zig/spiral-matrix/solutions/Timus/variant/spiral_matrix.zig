const std = @import("std");
const mem = std.mem;

pub fn spiral(allocator: mem.Allocator, size: u16) mem.Allocator.Error![][]u16 {
    var data = try allocator.alloc([]u16, size);
    var rows: usize = 0;
    errdefer {
        for (0..rows) |r| allocator.free(data[r]);
        allocator.free(data);
    }
    while (rows < size) : (rows += 1)
        data[rows] = try allocator.alloc(u16, size);
    var n: u16 = 1;
    if (size == 1) {
        data[0][0] = n;
    } else if (size > 1) {
        var j: usize = size - 1;
        for (0 .. size >> 1) |i| {
            const delta: u16 = @intCast(j - i);
            for (i..j) |k| {
                data[i][k], data[k][j] = .{ n, n - delta };
                n += 1;
            }
            n += delta;
            var k = j;
            while (k > i) : (k -= 1) {
                data[j][k], data[k][i] = .{ n, n + delta };
                n += 1;
            }
            n += delta;
            j -= 1;
        }
        if (size % 2 > 0)
            data[size >> 1][size >> 1] = n;
    }
    return data;
}
