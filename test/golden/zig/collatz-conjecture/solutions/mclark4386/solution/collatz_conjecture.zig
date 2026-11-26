pub const ComputationError = error{IllegalArgument};
pub fn steps(number: usize) anyerror!usize {
    if (number <= 0) return ComputationError.IllegalArgument;
    var s: usize = 0;
    var num = number;
    while (num != 1) {
        if (num % 2 == 0) {
            num /= 2;
        } else {
            num = 3 * num + 1;
        }
        s += 1;
    }
    return s;
}
