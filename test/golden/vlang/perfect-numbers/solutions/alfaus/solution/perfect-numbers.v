module main

pub enum Number {
	perfect
	abundant
	deficient
}

// returns a `Result` type
pub fn classify(candidate int) !Number {
    if candidate < 1 {
        return error('Classification is only possible for positive integers.')
    }
    mut factors := []int{}
    for i in 1..candidate {
        if candidate % i == 0 {
            factors << i
        }
    }
    mut sum := 0
    for f in factors{
        sum += f
    }
    if sum > candidate {
        return .abundant
    } else if sum < candidate {
        return .deficient
    } else {
        return .perfect
    }
}
