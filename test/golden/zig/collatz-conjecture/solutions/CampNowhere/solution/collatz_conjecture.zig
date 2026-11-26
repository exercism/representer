pub const ComputationError = error{IllegalArgument};

pub fn steps(number: usize) anyerror!usize {
    if (number < 1) {
        return ComputationError.IllegalArgument;
    }
    var i: usize = number;
    var s: usize = 0;
    while (i != 1) : (s += 1) {
        if (i % 2 == 0) {
            i = i / 2;
        } else {
            i = i * 3 + 1;
        }
    }
    return s;
}
