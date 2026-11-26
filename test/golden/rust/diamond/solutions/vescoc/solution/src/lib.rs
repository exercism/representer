pub fn get_diamond(c: char) -> Vec<String> {
    let size = (c as u8 - b'A') as usize;
    let dim = size * 2 + 1;

    let part = || (b'A'..c as u8).enumerate();

    let line = || std::iter::repeat(' ').take(dim).enumerate();

    let filler = |(i, c)| {
        line()
            .map(|(j, s)| {
                if j == size - i || j == size + i {
                    c as char
                } else {
                    s
                }
            })
            .collect::<String>()
    };

    part()
        .map(filler)
        .chain(std::iter::once(
            line()
                .map(|(j, s)| if j == 0 || j == dim - 1 { c as char } else { s })
                .collect::<String>(),
        ))
        .chain(part().rev().map(filler))
        .collect()
}
