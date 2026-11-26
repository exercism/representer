const std = @import("std");

pub const TransmissionError = error{
    WrongParity,
};

pub fn transmitSequence(allocator: std.mem.Allocator, message: []const u8) std.mem.Allocator.Error![]u8 {
    var encoded = std.ArrayList(u8).empty;
    errdefer encoded.deinit(allocator);

    var i: usize = 0;
    var buffer: u16 = 0;
    var len: u4 = 0;
    while (len >= 7 or i < message.len) {
        if (len < 7) {
            buffer <<= 8;
            buffer |= message[i];
            len += 8;
            i += 1;
        }

        var packet: u8 = @truncate((buffer >> (len - 7)) & 0b111_1111);
        const parity: u1 = @truncate(@popCount(packet));
        packet = (packet << 1) | parity;
        len -= 7;

        try encoded.append(allocator, packet);
    }

    if (len != 0) {
        var packet: u8 = @truncate(buffer << (8 - len));

        const parity: u1 = @truncate(@popCount(packet));
        packet = packet | parity;

        try encoded.append(allocator, packet);
    }

    return encoded.toOwnedSlice(allocator);
}

pub fn decodeMessage(allocator: std.mem.Allocator, message: []const u8) (std.mem.Allocator.Error || TransmissionError)![]u8 {
    var decoded = std.ArrayList(u8).empty;
    errdefer decoded.deinit(allocator);

    var buffer: u16 = 0;
    var len: u4 = 0;
    for (message) |packet| {
        if (@popCount(packet) % 2 != 0) return TransmissionError.WrongParity;

        buffer <<= 7;
        buffer |= packet >> 1;
        len += 7;

        if (len >= 8) {
            try decoded.append(allocator, @truncate(buffer >> (len - 8)));
            len -= 8;
        }
    }

    return decoded.toOwnedSlice(allocator);
}
