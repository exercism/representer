/// Determines whether the supplied string is a valid ISBN number
pub fn is_valid_isbn(isbn: &str) -> bool {
    let parse_isbn_digit = |ch| match ch {
        '0'..='9' => Some(ch as u32 - '0' as u32),
        'X' => Some(10),
        _ => None,
    };
    isbn.chars()
        .filter(|&ch| ch != '-')
        .map(parse_isbn_digit)
        .try_fold((10, 0), |(multiplier, sum), digit| {
            digit
                .filter(|&digit| multiplier == 1 || multiplier != 0 && digit != 10)
                .and_then(|digit| Some((multiplier - 1, sum + multiplier * digit)))
        })
        .map_or(false, |(multiplier, sum)| multiplier == 0 || sum % 11 == 0)
}
