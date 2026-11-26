const BASE_10: u32 = 10;
const MIN_SIZE: usize = 2;

/// Check a Luhn checksum.
///
/// The Luhn algorithm is a simple checksum formula used to validate a variety of identification
/// numbers, such as credit card numbers and Canadian Social Insurance Numbers.
/// An identification number is considered invalid (`false`) if it contains any character other
/// than a whitespace or a decimal digit (`0` to `9`).
pub fn is_valid(code: &str) -> bool {
    let code = code.trim();

    if code.len() < MIN_SIZE {
        return false;
    }

    let checksum = code
        .chars()
        .rev()
        .filter(|c| !c.is_whitespace())
        .enumerate()
        // "Double" every other digit (starting with the next-to-last digit); use a boolean in the
        // expression to avoid a final wildcard.
        // `to_digit` returns a `None` if it isn't a valid digit in the given radix (base 10),
        // which means an invalid number.
        .map(|(idx, c)| {
            let digit = c.to_digit(BASE_10)?;
            if idx & 1 != 0 {
                Some(luhn_doubling(digit))
            } else {
                Some(digit)
            }
        })
        .sum::<Option<u32>>();

    // In case of `None` (invalid digit in the code), return `false`; otherwise, validate.
    checksum.map_or(false, |n| n % 10 == 0)
}

// Double the digit; if the result is higher than 10, sum those digits (subtracting 9 gives the
// same result).
fn luhn_doubling(digit: u32) -> u32 {
    if digit <= 4 {
        2 * digit
    } else {
        2 * digit - 9
    }
}
