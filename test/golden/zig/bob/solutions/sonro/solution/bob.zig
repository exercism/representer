pub fn response(s: []const u8) []const u8 {
    var caps = false;
    var no_words = true;
    var silent = true;
    var question = false;

    for (s) |c| {
        if (c == ' ' or c == '\t' or c == '\n' or c == '\r') continue;
        silent = false;
        question = c == '?';
        if (c >= 'A' and c <= 'Z' and no_words) caps = true;
        if (c >= 'a' and c <= 'z' and caps) {
            caps = false;
            no_words = false;
        }
    }

    if (silent) return "Fine. Be that way!";
    if (question) {
        return if (caps) "Calm down, I know what I'm doing!" else "Sure.";
    }
    if (caps) return "Whoa, chill out!";
    return "Whatever.";
}
