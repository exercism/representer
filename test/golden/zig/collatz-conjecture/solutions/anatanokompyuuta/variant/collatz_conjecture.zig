// Please implement the `ComputationError.IllegalArgument` error.

pub const ComputationError = error{
    IllegalArgument,
};

pub fn steps(number: usize) ComputationError!usize {
    return recurse_steps(number, 0);
}

fn recurse_steps(number: usize, step_count: usize) !usize {
    if (number == 0) return ComputationError.IllegalArgument;
    if (number == 1) return step_count;
    if (number & 1 == 1) {
        return recurse_steps((3 * number) + 1, step_count - 1);
    } else {
        return recurse_steps(number / 2, step_count + 1);
    }
}