package all_your_base

import "core:slice"
Error :: enum {
    None,
    Invalid_Input_Digit,
    Input_Base_Too_Small,
    Output_Base_Too_Small,
    Unimplemented,
}

rebase :: proc(input_base: int, digits: []int, output_base: int) -> ([]int, Error) {
    if input_base < 2 do return nil, .Input_Base_Too_Small
    if output_base < 2 do return nil, .Output_Base_Too_Small

    value, err := calc_input(input_base, digits)
    if err != .None do return nil, err

    return calc_output(output_base, value)
}

@(private = "file")
calc_input :: proc(input_base: int, digits: []int) -> (int, Error) {
    value := 0
    for digit in digits {
        if digit < 0 || digit >= input_base do return 0, .Invalid_Input_Digit
        value = value * input_base + digit
    }

    return value, .None
}

@(private = "file")
calc_output :: proc(output_base: int, value: int) -> ([]int, Error) {
    result: [dynamic]int

    remaining := value
    for remaining > 0 {
        append(&result, remaining % output_base)
        remaining /= output_base
    }
    slice.reverse(result[:])

    if len(result) == 0 do append(&result, 0)

    return result[:], .None
}
