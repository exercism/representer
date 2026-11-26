const std = @import("std");
const mem = std.mem;
const ascii = std.ascii;

const State = enum {
    whitespace,
    word,

    fn transition(self: State, symbol: u8) State {
        return if (ascii.isAlpha(symbol))
            State.word
        else if (self == State.word and symbol == '\'')
            State.word
        else
            State.whitespace;
    }
};

pub fn abbreviate(allocator: mem.Allocator, words: []const u8) mem.Allocator.Error![]u8 {
    var acronym = std.ArrayList(u8).init(allocator);
    var state = State.whitespace;
    for (words) |symbol| {
        const new_state = state.transition(symbol);
        if (state == State.whitespace and new_state == State.word) {
            try acronym.append(ascii.toUpper(symbol));
        }
        state = new_state;
    }
    return acronym.toOwnedSlice();
}
