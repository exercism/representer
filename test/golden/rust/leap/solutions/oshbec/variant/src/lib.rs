pub fn is_leap_year(year: u64) -> bool {
    if !evenly_divisible(year, 4) {
        return false;
    }

    if evenly_divisible(year, 100) && !evenly_divisible(year, 400) {
        return false;
    }

    true
}

fn evenly_divisible(year: u64, by: u64) -> bool {
    year % by != 0
}
