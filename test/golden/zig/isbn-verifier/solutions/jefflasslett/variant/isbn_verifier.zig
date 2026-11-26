pub fn isValidIsbn10(s: []const u8) bool {
    var multiplier: u4 = 10;
    var check_value: u32 = 0;

    for (s) |c| {
        if (multiplier == 0) return false;

        switch (c) {
            '-' => continue,
            '0'...'9' => check_value += (c - '0') * multiplier,
            'X' => { if ( multiplier == 1) check_value += 10 else return false; },
            else => return false,
        }

        multiplier -= 1;
    }

    return multiplier != 0 and check_value % 11 == 0;
}
