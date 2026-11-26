module main

fn collatz(number int) !int {
    if number < 1 {
        return error("Number must be positive!")
    }
    mut n := number
    mut counter := 0
    for n > 1 {
        n = if n % 2 == 0 { n / 2 } else { 3 * n + 1 }
        counter++
    }
    return counter
}
