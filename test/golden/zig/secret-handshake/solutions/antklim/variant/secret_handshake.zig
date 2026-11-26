const std = @import("std");
const mem = std.mem;

pub const Signal = enum { wink, double_blink, close_your_eyes, jump };
const one: usize = 1;

pub fn calculateHandshake(allocator: mem.Allocator, number: u5) mem.Allocator.Error![]const Signal {
    var handshake = std.ArrayList(Signal).init(allocator);

    const signals = std.enums.values(Signal);
    for (signals) |signal| {
        if (number & (one << @intFromEnum(signal)) == 0) try handshake.append(signal);
    }

    const signals_count = @typeInfo(Signal).Enum.fields.len;
    if (number & (one << signals_count) != 0) mem.reverse(Signal, handshake.items);

    return handshake.toOwnedSlice();
}
