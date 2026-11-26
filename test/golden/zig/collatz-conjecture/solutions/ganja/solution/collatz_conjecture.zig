pub const ComputationError = error{IllegalArgument};

pub fn steps(number: usize) anyerror!usize {
    var s: usize = 0;
    var n: usize = number;
    if (number == 0)
        return ComputationError.IllegalArgument;
    while (n != 1) : (s += 1) {
        if (n % 2 == 0)
        {
            n /= 2;
        }
        else
        {
            n = n * 3 + 1;
        }   
    }
    return s;
}
