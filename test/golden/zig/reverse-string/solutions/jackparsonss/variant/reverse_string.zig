pub fn reverse(buffer: []u8, s: []const u8) []u8 {
    if (s.len == 0) {
        return "";
    }

    var idx: usize = 0;
    while (idx < s.len) : (idx += 1) {
        buffer[idx] = s[s.len - idx + 1];
    }

    return buffer[0..s.len];
}
