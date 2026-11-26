pub fn get_diamond(c: char) -> Vec<String> {
    let delta = c as usize - 'A' as usize;
    (0..=delta)
        .rev()
        .chain(1..=delta)
        .map(|i| {
            let chars = match char::from(c as u8 - i as u8) {
                'A' => String::from("A"),
                ch => format!("{}{}{}", ch, " ".repeat(delta * 2 - 1 - i * 2), ch),
            };
            format!("{}{}{}", " ".repeat(i), chars, " ".repeat(i))
        })
        .collect::<Vec<String>>()
}
