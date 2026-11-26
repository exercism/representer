// Please implement the `ComputationError.IllegalArgument` error.
pub const ComputationError = error{
    IllegalArgument,
};

pub fn steps(number: usize) ComputationError!usize {
    if (number == 0) return ComputationError.IllegalArgument;

    var n = number;
    var step: usize = 0;

    while (n > 1) : (step += 1) {
        n = if (n % 2 == 0)
            n / 2
        else
            3 * n + 1;
    }
    return step;
}
