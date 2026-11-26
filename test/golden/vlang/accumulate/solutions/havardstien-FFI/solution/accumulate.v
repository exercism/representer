module main

fn accumulate_ints(values []int, operation fn (int) int) []int {
    return []int{len: values.len, init: operation(values[index])}
}

fn accumulate_strs(values []string, operation fn (string) string) []string {
    return []string{len: values.len, init: operation(values[index])}
}


// Because V functions cannot be overloaded[1], make another function
//  called `accumulate_strs` that does the same thing for strings
// instead of ints
