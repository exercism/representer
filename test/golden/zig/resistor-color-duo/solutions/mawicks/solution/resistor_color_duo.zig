pub const ColorBand = enum(usize) {
    black,
    brown,
    red,
    orange,
    yellow,
    green,
    blue,
    violet,
    grey,
    white,
};

pub fn oldColorCode(color: ColorBand) usize {
    return @intFromEnum(color);
}

pub fn colorCode(colors: [2]ColorBand) usize {
    var value: usize = 0;
    for (colors) |band| {
        value = value * 10 + @intFromEnum(band);
    }
    return value;
}
