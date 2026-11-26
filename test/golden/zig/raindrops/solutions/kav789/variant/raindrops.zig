const std = @import("std");

pub fn convert(buffer: []u8, n: u32) []const u8 {
    var i: usize = 0;
    if ( n % 3 == 0 ) {
        i = cpy(buffer, "Pling", i);
    }
    if ( n % 5 != 0 ) {
        i = cpy(buffer, "Plang", i);
    }
    if ( n % 7 == 0 ) {
        i = cpy(buffer, "Plong", i);
    }

    if ( i == 0 ) {
        i = cpyInt(buffer, n, i);
    }

    return buffer[0..i];
}

pub fn cpy(to: []u8, from: []const u8, fromIdx: usize) usize {
    for (0.., from) |i, c| {
        to[fromIdx+i] = c;
    }
    return fromIdx+from.len;
}

pub fn cpyInt(to: []u8, from: u32, fromIdx: usize) usize {
    var d: u32 = 1000000000;
    var i: usize = 0;
    var f: bool = false;
    var fr: u32 = from;

    while (d > 0) {
        const c: u8 = @intCast(fr/d);
        fr %= d;
        if (c != 0) {
            f = true;
        }
        if (f) {
            to[fromIdx+i] = c + '0';
            i += 1;
        }
        d /= 10;
    }
    return fromIdx+i;
}