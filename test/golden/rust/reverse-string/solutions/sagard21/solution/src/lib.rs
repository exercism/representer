pub fn reverse(input: &str) -> String {
    let input_vec: Vec<char> = input.chars().collect();
    let rev_input_vec: Vec<char> = input_vec.iter().copied().rev().collect();
    let rev_str: String = rev_input_vec.into_iter().collect();

    return rev_str
}
