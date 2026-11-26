const BobResponses = enum {
    Sure, Whoa, Calm, Silence, Whatever,
    fn str(self: BobResponses) []const u8 {
        return switch (self) {
            .Sure => "Sure.",
            .Whoa => "Whoa, chill out!",
            .Calm => "Calm down, I know what I'm doing!",
            .Silence => "Fine. Be that way!",
            .Whatever => "Whatever.",
        };
    }
};
const DetectCapitals = enum { None, MaybeAll, LowercaseFound };
const HasSpoken = enum { None, NoLetters, WithLetters };
pub fn response(s: []const u8) []const u8 {
    var is_question = false;
    var has_spoken: HasSpoken = .None;
    var detect_capitals: DetectCapitals = .None;
    for (s) |ch| {
        if (@import("std").ascii.isWhitespace(ch)) continue;
        if (has_spoken == .None) has_spoken = .NoLetters;
        is_question = false;
        switch (ch) {
            'A'...'Z' => {
                if (detect_capitals == .None) detect_capitals = .MaybeAll;
                has_spoken = .WithLetters;
            },
            'a'...'z' => {
                detect_capitals = .LowercaseFound;
                has_spoken = .WithLetters;
            },
            '?' => is_question = true,
            else => continue,
        }
    }
    if (has_spoken == .None) {
        return BobResponses.Silence.str();
    } else if (has_spoken == .WithLetters) {
        if (detect_capitals == .MaybeAll) 
            return if (is_question) BobResponses.Calm.str() else BobResponses.Whoa.str();
    }
    return if (is_question) BobResponses.Sure.str() else BobResponses.Whatever.str();
}
