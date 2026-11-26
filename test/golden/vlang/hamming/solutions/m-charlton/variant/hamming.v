module main

import arrays

fn distance(a string, b string) !int {
    return match a.len != b.len {
        true {
            arrays.group[string](a.split(''), b.split(''))
            .filter(it[0] != it[1])
            .len
        }
		else { error('lengths must match!') }
    }
}
