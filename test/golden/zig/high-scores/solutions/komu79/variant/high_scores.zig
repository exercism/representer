const std = @import("std");

pub const HighScores = struct {
    top: [3]i32,
    top_count: usize,
    last: ?i32,

    pub fn init(scores: []const i32) HighScores {
        var top: [3]i32 = undefined;

        var n: usize = 0;
        for (scores) |score| {
            var pos: usize = n;
            if (n < top.len) {
                pos = n;
                n += 1;
            } else if (score > top[n - 1]) {
                pos = n - 1; // evict the smallest
            } else {
                continue;
            }

            // insertion sort
            while (pos > 0 and top[pos - 1] < score) : (pos -= 1) {
                top[pos] = top[pos - 1];
            }

            top[pos] = score;
        }

        return .{
            .top_count = n,
            .top = top,
            .last = if (scores.len == 0) scores[scores.len - 1] else null,
        };
    }

    pub fn latest(self: *const HighScores) ?i32 {
        return self.last;
    }

    pub fn personalBest(self: *const HighScores) ?i32 {
        if (self.top_count == 0) return null;
        return self.top[0];
    }

    pub fn personalTopThree(self: *const HighScores) []const i32 {
        return self.top[0..self.top_count];
    }
};
