module main

import math

fn square_root(radicand u64) u64 {

    mut bottom := u64(1)
    mut top := radicand
    mut root := u64(0)

    if radicand == 0 {
        return 0
    }

    for top - bottom > 1 {
        mut middle := find_middle(bottom, top)
        if (middle * middle) >= radicand {
            top = middle
        }
        else {
            bottom = middle
        }
    }
    if (top * top) - radicand > radicand - (bottom * bottom) {
        root = bottom
    }
    else {
        root = top
    }
    
    return root

}

fn find_middle(low u64, high u64) u64 {
    return u64(low + math.ceil((high - low) / 2))
}