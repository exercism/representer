const std = @import("std");
const fmt = std.fmt;
const isDigit = std.ascii.isDigit;

pub fn encode(buffer: []u8, string: []const u8) []u8 {
    var stream = std.io.fixedBufferStream(buffer);
    var writer = stream.writer();
    var rest: []const u8 = string;
    while (rest.len > 0) {
        var position: usize = 0;
        const first: u8 = rest[0];
        while (position < rest.len and rest[position] == first) : (position += 1) {}
        if (position == 1) {
            writer.writeByte(first) catch unreachable;
        } else {
            writer.print("{d}{c}", .{ position, first }) catch unreachable;
        }
        rest = rest[position..];
    }
    return stream.getWritten();
}

pub fn decode(buffer: []u8, string: []const u8) []u8 {
    var stream = std.io.fixedBufferStream(buffer);
    var writer = stream.writer();
    var rest: []const u8 = string;
    while (rest.len > 0) {
        var position: usize = 0;
        while (isDigit(rest[position])) : (position += 1) {}
        const num = std.fmt.parseInt(u32, rest[0..position], 10) catch 1;
        writer.writeByteNTimes(rest[position], num) catch unreachable;
        rest = rest[position + 1 ..];
    }
    return stream.getWritten();
}
