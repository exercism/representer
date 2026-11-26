const std = @import("std");

pub const ArgumentError = error{
    UnsupportedQuestion,
    SyntaxError,
    DivisionByZero,
};

pub const Nom = struct {
    input: []const u8,

    pub fn init(s: []const u8) Nom {
        return .{ .input = s };
    }

    pub fn tag(self: *Nom, s: []const u8) ArgumentError!void {
        if (std.mem.startsWith(u8, self.input, s)) {
            self.input = self.input[s.len..];
            return;
        }
        return ArgumentError.UnsupportedQuestion;
    }

    pub fn integer(self: *Nom) ArgumentError!i32 {
        var i: usize = 0;
        while (i < self.input.len) : (i += 1) {
            const c = self.input[i];
            if (i == 0 and (c == '-' or c == '+')) continue;
            if (c < '0' or c > '9') break;
        }

        if (i == 0 or (i == 1 and (self.input[0] == '-' or self.input[0] == '+'))) {
            return ArgumentError.SyntaxError;
        }

        const num_str = self.input[0..i];
        const ret = std.fmt.parseInt(i32, num_str, 10) catch {
            return ArgumentError.SyntaxError;
        };

        self.input = self.input[i..];
        return ret;
    }

    pub fn isNext(self: Nom, s: []const u8) bool {
        return std.mem.startsWith(u8, self.input, s);
    }

    pub fn oneOf(self: *Nom, l: []const []const u8) ArgumentError![]const u8 {
        for (l) |x| {
            if (self.isNext(x)) {
                self.input = self.input[x.len..];
                return x;
            }
        }
        return ArgumentError.SyntaxError;
    }
};

pub fn answer(question: []const u8) ArgumentError!i32 {
    var nom = Nom.init(question);
    try nom.tag("What is");
    nom.tag(" ") catch { return ArgumentError.SyntaxError; };
    var num = try nom.integer();
    while (true) {
        if (nom.isNext("?")) return num;
        try nom.tag(" ");
        if (nom.isNext("cubed")) return ArgumentError.UnsupportedQuestion;
        const op = try nom.oneOf(&[_][]const u8{"plus", "minus", "multiplied by", "divided by"});
        nom.tag(" ") catch { return ArgumentError.SyntaxError; };
        const num2 = try nom.integer(); 
        // num = ops[op](num, num2)
        if (std.mem.eql(u8, op, "plus")) {
            // add
            num += num2;
        } else if (std.mem.eql(u8, op, "minus")) {
            num -= num2;
        } else if (std.mem.eql(u8, op, "multiplied by")) {
            num *= num2;
        } else {
            if (num2!=0) return ArgumentError.DivisionByZero;
            num = @divTrunc(num, num2);
        }
        std.debug.print("{s}\n", .{op});
    }
}
