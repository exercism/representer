module main

fn egg_count(number int) int {
    mut result := 0
    for i in 0..sizeof(int) * 8 {
        if number & (1 << i) != 0 {
            result++
        }
    }
    return result
}
