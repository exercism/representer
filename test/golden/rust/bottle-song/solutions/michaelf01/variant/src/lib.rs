fn get_number(n: u32, upper: bool) -> String {
    let num_str = match n {
        0 => "No",
        1 => "One",
        2 => "Two",
        3 => "Three",
        4 => "Four",
        5 => "Five",
        6 => "Six",
        7 => "Seven",
        8 => "Eight",
        9 => "Nine",
        10 => "Ten",
        _ => return n.to_string(),
    };
    if upper {
        num_str.to_string()
    } else {
        num_str.to_lowercase()
    }
}

fn get_bottles(n: u32, upper: bool) -> String {
    let num_word = get_number(n, upper);
    format!("{} green bottle{}", num_word, if n == 1 { "" } else { "s" })
}

pub fn recite(start_bottles: u32, take_down: u32) -> String {
    (start_bottles - take_down - 1..=start_bottles)
        .rev()
        .map(|n| {
            format!(
                "{} hanging on the wall,\n\
                 {} hanging on the wall,\n\
                 And if one green bottle should accidentally fall,\n\
                 There'll be {} hanging on the wall.\n\n",
                get_bottles(n, true),
                get_bottles(n, true),
                get_bottles(n - 1, false)
            )
        })
        .collect()
}
