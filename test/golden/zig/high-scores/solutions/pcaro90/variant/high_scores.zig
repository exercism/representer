const std = @import("std");

pub const HighScores = struct {
    scores: []const i32,

    pub fn init(scores: []const i32) HighScores {
        return HighScores{
            .scores = scores,
        };
    }

    pub fn latest(self: *const HighScores) ?i32 {
        return self.scores[self.scores.len - 1];
    }

    pub fn personalBest(self: *const HighScores) ?i32 {
        if (self.scores.len == 0) return null;
        var max: i32 = self.scores[0];
        for (self.scores[1..]) |s| {
            if (s >= max) max = s;
        }
        return max;
    }

    pub fn personalTopThree(self: *const HighScores) []const i32 {
        var scores: []i32 = @constCast(self.scores);
        std.sort.block(i32, scores, {}, comptime std.sort.desc(i32));
        return scores[0..@min(3, scores.len)];
    }
};
