
use std::collections::HashMap;

type Domino = (u8, u8);

pub fn chain(input: &[Domino]) -> Option<Vec<Domino>> {
    
    // we can't mutate the original array, so make a copy
    // to play with.
    let mut dominoes = input.to_vec();

    if invalid_input(input) {
        None
    } else if input.len() < 2 {
        // single domino, just send it back.
        Some(Vec::from(input))
    } else if chained(&mut dominoes) {
        // all successfully done.
        Some(dominoes)
    } else {
        // chained() failed
        None
    }
}

// look at the first domino and then check all the other
// tiles that might fit onto it.
// Exit as soon as a chain is found. 
// 
// I don't like using recursion, but I'll think about an
// iterative solution later.
fn chained(input: &mut [Domino]) -> bool {
    if input.len() < 2 {
        return true;
    };

    for idx in find_tiles(&input[1..], input[0].1) {
        // put the candidate in place
        input.swap(1, idx + 1);
        if input[0].1 != input[1].0 {
            reverse(&mut input[1]);
        }
        // recursive call to chain up the remainder
        if chained(&mut input[1..]) {
            return true;
        }
        // restore the original order
        input.swap(1, idx + 1);
    }
    return false;
}

// swap around a domino in-place
fn reverse(dom: &mut Domino) {
    *dom = (dom.1, dom.0);
}

// look through the array and find any tiles that contain
// the number.
fn find_tiles(input: &[Domino], target: u8) -> Vec<usize> {
    let mut res = Vec::<usize>::new();
    
    for (idx, dom) in input.iter().enumerate() {
        if dom.0 == target || dom.1 == target {
            res.push(idx);
        }
    };
    res
}

// validate that the input is chainable: there must be an
// even number of half-tiles with every number. 
fn invalid_input(input: &[Domino]) -> bool {
    let mut map: HashMap<u8, usize> = HashMap::new();
    for tuple in input {
        for dots in [tuple.0, tuple.1] {
            match map.get_mut(&dots) {
                Some(v) => *v += 1,
                None => { map.insert(dots, 1); },
            };
        }
    }
    // invalid if any number has odd num of entries
    map.values().any(|&v| v & 1 == 1)
}
