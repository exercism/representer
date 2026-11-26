pub trait Luhn {
    fn valid_luhn(&self) -> bool;
}

// Generic helper function to validate Luhn algorithm
fn check_luhn(code: &str) -> bool {
    let code = code.replace(' ', "");

    // Must have at least 2 digits and all must be digits
    if code.len() < 1 || !code.chars().all(|c| c.is_ascii_digit()) {
        return false;
    }

    let sum: u32 = code
        .chars()
        .rev()
        .filter_map(|c| c.to_digit(10))
        .enumerate()
        .map(|(i, n)| {
            if i % 2 == 1 {
                let doubled = n * 2;
                if doubled > 9 {
                    doubled - 9
                } else {
                    doubled
                }
            } else {
                n
            }
        })
        .sum();

    sum % 10 == 0
}

// Implement Luhn for &str
impl Luhn for &str {
    fn valid_luhn(&self) -> bool {
        check_luhn(self)
    }
}

// Implement Luhn for String
impl Luhn for String {
    fn valid_luhn(&self) -> bool {
        check_luhn(self)
    }
}

// Implement Luhn for numeric types (convert to string)
macro_rules! impl_luhn_for_int {
    ($($t:ty),*) => {
        $(
            impl Luhn for $t {
                fn valid_luhn(&self) -> bool {
                    check_luhn(&self.to_string())
                }
            }
        )*
    };
}

// Support multiple number types
impl_luhn_for_int!(u8, u16, u32, u64, usize, i8, i16, i32, i64, isize);
