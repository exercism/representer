const std = @import("std");
const mem = std.mem;

/// Encodes `msg` using the rail fence cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    var output: []u8 = try allocator.alloc(u8, msg.len * rails);
    defer allocator.free(output);
    @memset(output, 0);

    var rail: u3 = 0;
    var upward = true;
    for (msg, 0..) |c, i| {
        if (rail == 0) {
            upward = false;
        }
        if (rail == rails - 1) {
            upward = true;
        }
        output[i + rail * msg.len] = c;
        if (!upward) {
            rail += 1;
        } else {
            rail -= 1;
        }
    }
    var i: usize = 0;
    var o2: []u8 = try allocator.alloc(u8, msg.len);
    errdefer allocator.free(o2);

    for (output) |c| {
        if (c != 0) {
            o2[i] = c;
            i += 1;
        }
    }

    return o2;
}

/// Decodes `msg` using the rail fence cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, msg: []const u8, rails: u3) mem.Allocator.Error![]u8 {
    var output: []u8 = try allocator.alloc(u8, msg.len);
    errdefer allocator.free(output);

    const max: usize = @as(usize, rails - 1) * 2;
    var j: usize = 0;

    for (0..rails) |i| {
        var n: usize = 0;

        const offset = max - (i % (rails - 1) * 2);
        var inc: usize = offset;
        var c: usize = 0;

        while (i + n < msg.len) : (n += inc) {
            c += 1;

            output[i + n] = msg[j];

            inc = if (i % (rails - 1) != 0 and c % 2 == 0) max - offset else offset;
            j += 1;
        }
    }

    return output;
}
