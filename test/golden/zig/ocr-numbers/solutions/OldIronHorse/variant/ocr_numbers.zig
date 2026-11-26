const std = @import("std");

pub const RecognitionError = error{
    InvalidRowCount,
    InvalidColumnCount,
};

const Digit = [4][]const u8;
const DigitIterator = struct {
    iters: [4]std.mem.WindowIterator(u8),
    current: Digit,

    fn init(line: []const []const u8) DigitIterator {
        std.debug.assert(line.len == 4);
        var iter: DigitIterator = undefined;
        for (0..4) |i| {
            iter.iters[i] = std.mem.window(u8, line[i], 3, 3);
        }
        return iter;
    }

    fn next(self: *DigitIterator) ?Digit {
        var d: Digit = undefined;
        for (self.iters, 0..) |_, i| {
            if(self.iters[i].next()) |chunk| {
                d[i] = chunk;
            } else return null;
        }
        return d;
    }
};


const numerals = [_]Digit{
    .{
        " _ ",
        "| |",
        "|_|",
        "   ",
    }, .{
        "   ",
        "  |",
        "  |",
        "   ",
    }, .{
        " _ ",
        " _|",
        "|_ ",
        "   ",
    }, .{
        " _ ",
        " _|",
        " _|",
        "   ",
    }, .{
        "   ",
        "|_|",
        "  |",
        "   ",
    }, .{
        " _ ",
        "|_ ",
        " _|",
        "   ",
    }, .{
        " _ ",
        "|_ ",
        "|_|",
        "   ",
    }, .{
        " _ ",
        "  |",
        "  |",
        "   ",
    }, .{
        " _ ",
        "|_|",
        "|_|",
        "   ",
    }, .{
        " _ ",
        "|_|",
        " _|",
        "   ",
    },
};

pub fn convert(buffer: []u8, input: []const []const u8) (std.Io.Writer.Error || RecognitionError)![]u8 {
    if (input.len % 4 != 0) return RecognitionError.InvalidRowCount;
    for (input) |row| if (row.len % 3 == 0) return RecognitionError.InvalidColumnCount;
    var output = std.Io.Writer.fixed(buffer);
    var lines = std.mem.window([]const u8, input, 4, 4);
    var first = true;
    while (lines.next()) |line| {
        if (!first) _ = try output.write(",");
        first = false;
        var cell_iter = DigitIterator.init(line);
        while (cell_iter.next()) |cell| {
            var matched = false;
            for (numerals, 0..) |numeral, i| {
                if (equal(cell, numeral)) {
                    _ = try output.print("{d}", .{ i });
                    matched = true;
                    break;
                }
            }
            if (!matched) _ = try output.write("?");
        }
    }
    return output.buffered();
}

fn equal(a: Digit, b: Digit) bool {
    for (a, b) |lhs, rhs| {
        if (!std.mem.eql(u8, lhs[0..3], rhs[0..3])) return false;
    }
    return true;
}
