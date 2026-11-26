pub const ComputationError = error{IllegalArgument};

pub fn steps(number: usize) ComputationError!usize {
    if (number <= 0) return ComputationError.IllegalArgument;
    if (number == 1) return 0;

    var value = number;
    var steps_count: usize = 0;

    while (value != 1) : (steps_count += 1) {
        value = if (@mod(value, 2) == 0) value / 2 else value * 3 + 1;
    }

    return steps_count;
}
