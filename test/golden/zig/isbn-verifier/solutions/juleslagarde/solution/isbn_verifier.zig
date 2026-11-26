const CHECK_DIGIT_INDEX = 10 - 1;

pub fn isValidIsbn10(s: []const u8) bool {
    var sum: u64 = 0;
    var i: u16 = 0;
    for (s) |l| {
        if (l == '-') continue;
        if (l == 'X' and i != CHECK_DIGIT_INDEX) return false;
        const n: u64 = if (l == 'X') 10 else l - '0';
        sum += n * (10 - i);
        i += 1;
    }
    return i == 10 and sum % 11 == 0;
}
