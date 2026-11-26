package all_your_base

import "core:slice"
import "core:math"

Error :: enum {
	None,
	Invalid_Input_Digit,
	Input_Base_Too_Small,
	Output_Base_Too_Small,
	Unimplemented,
}

rebase :: proc(input_base: int, digits: []int, output_base: int) -> ([]int, Error) {
	if input_base < 2 {
        return nil, .Input_Base_Too_Small
    }
	if output_base < 2 {
        return nil, .Output_Base_Too_Small
    }
    decimal := 0
    for digit in digits {
        if digit < 0 || input_base <= digit {
            return nil, .Invalid_Input_Digit
        }
        decimal = decimal * input_base + digit
    }
    last := 0 if decimal == 0 else int(math.log_f64(f64(decimal), f64(output_base)))
    digits := make([]int, last + 1)
    if decimal == 0 {
        digits[0] = 0
    } else {
        for i := last; i >= 0; i -= 1 {
            digits[i] = decimal % output_base
            decimal /= output_base
        }
    }
	return digits, .None
}
