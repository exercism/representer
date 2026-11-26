const std = @import("std");

pub fn encode(buffer: []u8, string: []const u8) []u8 {
    var length: usize = 0;
    var it = RunIterator{ .string = string };

    while (it.next()) |run| {
        const written =
            if (run.length == 1)
            std.fmt.bufPrint(buffer[length..], "{c}", .{run.character})
        else
            std.fmt.bufPrint(buffer[length..], "{d}{c}", .{ run.length, run.character });
        length += (written catch unreachable).len;
    }

    return buffer[0..length];
}

pub fn decode(buffer: []u8, string: []const u8) []u8 {
    var index: usize = 0;
    var it = CodedRunIterator{ .string = string };

    while (it.next()) |run| {
        for (0..run.length) |_| {
            buffer[index] = run.character;
            index += 1;
        }
    }
    return buffer[0..index];
}

const Run = struct { character: u8, length: usize };

const RunIterator = struct {
    string: []const u8,
    index: usize = 0,

    fn next(self: *RunIterator) ?Run {
        var run: ?Run = null;
        while (self.index < self.string.len) {
            const character = self.string[self.index];
            if (run == null) {
                run = Run{ .character = character, .length = 1 };
                self.index += 1;
            } else if (run.?.character == character) {
                run.?.length += 1;
                self.index += 1;
            } else break;
        }
        return run;
    }
};

const CodedRunIterator = struct {
    string: []const u8,
    index: usize = 0,

    fn next(self: *CodedRunIterator) ?Run {
        var run = Run{ .character = 0, .length = 0 };
        while (self.index < self.string.len) {
            const character = self.string[self.index];
            if (std.ascii.isDigit(character)) {
                run.length = run.length * 10 + character - '0';
                self.index += 1;
            } else if (run.character == 0) {
                run.character = character;
                if (run.length == 0) run.length = 1;
                self.index += 1;
                return run;
            }
        }
        return null;
    }
};
