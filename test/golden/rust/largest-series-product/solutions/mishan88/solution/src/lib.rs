#[derive(Debug, PartialEq)]
pub enum Error {
    SpanTooLong,
    InvalidDigit(char),
}

pub fn lsp(string_digits: &str, span: usize) -> Result<u64, Error> {
    if span == 0 {
        return Ok(1);
    }
    if string_digits.len() < span {
        return Err(Error::SpanTooLong);
    }
    if string_digits.contains(|x: char| !x.is_numeric()) {
        return Err(Error::InvalidDigit(
            string_digits
                .chars()
                .filter(|x| !x.is_numeric())
                .collect::<String>()
                .chars()
                .last()
                .unwrap(),
        ));
    }

    Ok(string_digits
        .chars()
        .filter_map(|x| x.to_digit(10))
        .map(|x| x as u64)
        .collect::<Vec<u64>>()
        .windows(span)
        .map(|x| x.iter().product())
        .max()
        .unwrap())
}
