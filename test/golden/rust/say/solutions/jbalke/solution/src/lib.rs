mod sayint;
use sayint::SayInt;

pub fn encode(n: u64) -> String {
    SayInt::new(n).into()
}
