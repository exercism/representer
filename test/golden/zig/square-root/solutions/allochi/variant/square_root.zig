// Quake-style fast square root algorithm
pub fn squareRoot(radicand: usize) usize {
    if (radicand == 0) return 0;
    if (radicand == 1) return 1;

    // Bit Manipulation
    const x: f64 = @floatFromInt(radicand);
    const i: usize = @bitCast(x);
    const m: usize = (i >> 1) + (0x3fe << 51);
    var y: f64 = @bitCast(m);

    // Newton-Raphson Refinement
    y = 0.5 * (y + x * y);
    y = 0.5 * (y + x / y);
    y = 0.5 * (y + x / y);

    // Integer Correction
    var result: usize = @intFromFloat(y);
    while (result > 0 and result * result > radicand) {
        result -= 1;
    }

    while ((result + 1) * (result + 1) <= radicand) {
        result += 1;
    }

    return result;
}
