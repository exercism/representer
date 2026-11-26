# Returns the number of steps required to reach 1.
#
# + n - number
# + return - number of steps
function collatzSteps(int n) returns int|error {
    if n <= 0 {
        return error("Only positive integers are allowed");
    }

    var steps = 0;
    var a = n;
    while a > 1 {
        if a % 2 == 0 {
            a /= 2;
        } else {
            a *= 3;
            a += 1;
        }

        steps += 1;
    }

    return steps;
}
