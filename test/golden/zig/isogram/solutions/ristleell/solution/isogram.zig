const std = @import("std");
const BitSet = std.bit_set.IntegerBitSet(26);

pub fn isIsogram(str: []const u8) bool {
    var set = BitSet.initEmpty();

    for (str) |char| {
        const lowercase = toAsciiLower(char);
        const index = switch (lowercase) {
            'a'...'z' => lowercase - 'a',
            else => continue,
        };

        if (set.isSet(index)) return false;

        set.set(index);
    }

    return true;
}

fn toAsciiLower(ascii: u8) u8 {
    return switch (ascii) {
        'A'...'Z' => ascii - 'A' + 'a',
        else => ascii,
    };
}
