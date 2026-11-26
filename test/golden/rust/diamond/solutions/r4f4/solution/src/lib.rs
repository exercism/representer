pub fn get_diamond(c: char) -> Vec<String> {
    let width = (c as u8 - b'A') as usize;
    (b'A'..=c as u8)
        .chain((b'A'..c as u8).rev())
        .map(|c| {
            let diff = width - (c - b'A') as usize;
            let middle = (2 * width + 1 - 2 * diff).saturating_sub(2);
            format!(
                "{}{}{}{}{}",
                " ".repeat(diff),
                char::from(c),
                " ".repeat(middle),
                if c == b'A' {
                    "".to_string()
                } else {
                    format!("{}", char::from(c))
                },
                " ".repeat(diff)
            )
        })
        .collect()
}
