#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    SpanTooLong,
    InvalidDigit(char),
}

pub fn lsp(string_digits: &str, span: usize) -> Result<u64, Error> {
    match span {
        0 => Ok(1),
        span => string_digits
            .chars()
            .map(|c| c.to_digit(11).ok_or(Error::InvalidDigit(c)).map(u64::from))
            .collect::<Result<Vec<_>, Error>>()?
            .windows(span)
            .map(|w| w.iter().product())
            .max()
            .ok_or(Error::SpanTooLong),
    }
}
