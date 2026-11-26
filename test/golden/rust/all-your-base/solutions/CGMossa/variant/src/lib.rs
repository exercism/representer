#[derive(Debug, PartialEq)]
pub enum Error {
    InvalidInputBase,
    InvalidOutputBase,
    InvalidDigit(u32),
}

///
/// Convert a number between two bases.
///
/// A number is any slice of digits.
/// A digit is any unsigned integer (e.g. u8, u16, u32, u64, or usize).
/// Bases are specified as unsigned integers.
///
/// Return an `Err(.)` if the conversion is impossible.
/// The tests do not test for specific values inside the `Err(.)`.
///
///
/// You are allowed to change the function signature as long as all test still pass.
///
///
/// Example:
/// Input
///   number: &[4, 2]
///   from_base: 10
///   to_base: 2
/// Result
///   Ok(vec![1, 0, 1, 0, 1, 0])
///
/// The example corresponds to converting the number 42 from decimal
/// which is equivalent to 101010 in binary.
///
///
/// Notes:
///  * The empty slice ( "[]" ) is equal to the number 0.
///  * Never output leading 0 digits. However, your function must be able to
///     process input with leading 0 digits.
///
pub fn convert(number: &[u32], from_base: u32, to_base: u32) -> Result<Vec<u32>, Error> {
    if from_base <= 1 {
        return Err(Error::InvalidInputBase);
    } else if to_base <= 1 {
        return Err(Error::InvalidOutputBase);
    }

    if let Some(&a) = number
        .iter()
        .skip_while(|x| (0..from_base).contains(x))
        .next()
    {
        return Err(Error::InvalidDigit(a));
    }

    let number_wo_leading_digits = number.iter().take_while(|x| **x != 0).count();
    let (_, number_wo_leading_digits) = number.split_at(number_wo_leading_digits);

    //    if number_wo_leading_digits.is_empty() {
    //        return Ok(Vec::new());
    //    }

    let mut number_base_10 = number_wo_leading_digits
        .into_iter()
        .rev()
        .enumerate()
        .fold(0, |acc, (i, x)| acc + from_base.pow(i as u32) * *x);

    let leading_no_digits_output = (number_base_10 as f64).log(to_base as f64).floor() as u32 + 1;

    Ok((0..leading_no_digits_output)
        .rev()
        .fold(Vec::new(), |mut acc, x| {
            let (div, rem) = num::integer::div_rem(number_base_10, to_base.pow(x));
            number_base_10 = rem;
            acc.push(div);
            acc
        }))
}
