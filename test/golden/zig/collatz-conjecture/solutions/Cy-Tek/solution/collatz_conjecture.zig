pub const ComputationError = error{IllegalArgument};

pub fn steps(number: usize) anyerror!usize {
    return if (number == 0) error.IllegalArgument else steps_tail(number, 0);
}

fn steps_tail(number: usize, num_steps: usize) usize {
    if (number == 1) return num_steps;

    const num = if (@rem(number, 2) == 0) @divExact(number, 2) else number * 3 + 1;
    return @call(.always_tail, steps_tail, .{ num, num_steps + 1 });
}
