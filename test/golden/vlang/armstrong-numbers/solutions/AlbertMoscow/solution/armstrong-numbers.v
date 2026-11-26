module main

import math { powi }
import arrays { sum }

pub fn is_armstrong_number(number u32) bool {
    power := number.str().len    
    return number == sum(number.str().split('').map(powi(it.int(), power))) or {0}
}
