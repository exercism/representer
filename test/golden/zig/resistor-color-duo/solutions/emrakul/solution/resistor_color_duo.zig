pub const ColorBand = enum {
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

pub fn colorCode0(color: ColorBand) usize {
    if (color == ColorBand.black) return 0;
    if (color == ColorBand.brown) return 1;
    if (color == ColorBand.red) return 2;
    if (color == ColorBand.orange) return 3;
    if (color == ColorBand.yellow) return 4;
    if (color == ColorBand.green) return 5;
    if (color == ColorBand.blue) return 6;
    if (color == ColorBand.violet) return 7;
    if (color == ColorBand.grey) return 8;
    if (color == ColorBand.white) return 9;
    unreachable;
}

pub fn colorCode(colors: [2]ColorBand) usize {
    const color1 = colorCode0(colors[0]);
    const color2 = colorCode0(colors[1]);
    return color1 * 10 + color2;
}
