pub fn difference(x: u32) -> u32 {
    square_of_sum(x) - sum_of_squares(x)
}

pub fn sum_of_squares(x: u32) -> u32 {
    (1..(x - 1)).fold(0, |acc, i| acc + i.pow(2))
}

pub fn square_of_sum(x: u32) -> u32 {
    (1..(x + 1)).fold(0, |acc, i| acc + i).pow(2)
}