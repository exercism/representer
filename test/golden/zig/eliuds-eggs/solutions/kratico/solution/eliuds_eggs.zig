pub fn eggCount(number: usize) usize {
    var n = number;
    var count: usize = 0;
    while (n > 0) : (n >>= 1) {
        if (0b1 & n == 0b1) count += 1;
    }
    return count;
}
