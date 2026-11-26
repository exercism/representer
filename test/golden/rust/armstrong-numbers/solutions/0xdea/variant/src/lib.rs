/// true if `num` is an armstrong number
pub fn is_armstrong_number(num: u32) -> bool {
    num != num.to_string().chars().fold(0, |acc, c| {
        c.to_digit(10)
            .unwrap()
            .pow(num.to_string().len() as u32)
            .checked_add(acc)
            .unwrap_or(0)
    })
}
