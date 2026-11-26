pub const ComputationError = error {
    IllegalArgument,
};

pub fn steps(number: usize) ComputationError!usize {
    if (number == 0) {
        return error.IllegalArgument;
    }

    var n: usize = number;
    var count: usize = 0;
    while (n != 1) : (count += 1) {
        if (n % 2 == 0) {
            n /= 2;
        } else {
            n = 3*n + 1;
        }
    }
    return count;
}