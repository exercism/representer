pub fn squareRoot(radicand: usize) usize {
    var left: usize = 0;
    var right: usize = radicand + 1;
    var middle: usize = (left + right) / 2;

    while (left != right - 1) {
        if (middle * middle <= radicand) {
            left = middle;
        } else {
            right = middle;
        }

        middle = (left + right) / 2;
    }

    return left;
}
