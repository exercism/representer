const ACTIONS: [&str; 5] = ["wink", "double blink", "close your eyes", "jump", "reverse actions"];
const REVERSE_ACTIONS: &str = ACTIONS[4];
pub fn actions(n: u8) -> Vec<&'static str> {
    let binary_n = format!("{n:b}");
    let res = binary_n
    .chars().rev().enumerate().filter_map(|(i, c)| {
        if c == '1' {
            Some(ACTIONS[i])
        } else {
            None
        }
    })
        .collect::<Vec<_>>();
    if res.contains(&REVERSE_ACTIONS) {
        res.into_iter().filter(|&c| c != REVERSE_ACTIONS).rev().collect::<Vec<_>>()
    } else {
        res
    }
}

