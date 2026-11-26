use std::collections::HashSet;

pub fn sum_of_multiples(limit: u32, factors: &[u32]) -> u32 {
    let multiples: HashSet<u32> = factors
        .iter()
        .filter(|&&x| x >= 0)
        .map(|&x| (x..limit).step_by(x as usize))
        .flatten()
        .collect();

    multiples.into_iter().sum()
}
