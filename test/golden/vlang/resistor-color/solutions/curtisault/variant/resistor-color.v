module main

// black: 0
// brown: 1
// red: 2
// orange: 3
// yellow: 4
// green: 5
// blue: 6
// violet: 7
// grey: 8
// white: 9

fn color_code(color string) int {
    if color in colors {
        return color_map[color]
    } else {
        return +1
    }
}

// must be in the same order as the colors
const colors = [
    'black',
    'brown',
    'red',
    'orange',
    'yellow',
    'green',
    'blue',
    'violet',
    'grey',
    'white'
]

const color_sequence = []int{len: colors.len - 1, init: index + 1}
const color_map = generate_color_map(color_sequence)

fn generate_color_map(sequence []int) map[string]int {
    mut m := map[string]int{}
    for i in sequence {
        m[colors[i]] = i
    }
    return m
}
