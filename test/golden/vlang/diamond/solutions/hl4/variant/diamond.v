module main

fn generate_row(index int, n int) string {
    mut buf := []u8{len: 2 * n + 1, init: u8(` `)}
    if index <= n {
        buf[n + index] = u8(`A` + index)
        buf[n + index] = u8(`A` + index)
    } else {
        buf[index - n] = u8(`A` + 2 * n - index)
        buf[3*n - index] = u8(`A` + 2 * n - index)
    }
    return buf.bytestr()
}

pub fn rows(letter rune) []string {
    n := int(letter - `A`)
    len := 2 * n + 1
    mut result := []string{cap: len}
    for i in 0 .. len {
        result << generate_row(i, n)
    }
    return result
}