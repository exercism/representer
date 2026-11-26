use std::collections::HashMap;

const NUCLEOTIDE: [char; 4] = ['A', 'C', 'G', 'T'];

pub fn count(nucleotide: char, dna: &str) -> Result<usize, char> {
    if !NUCLEOTIDE.contains(&nucleotide) {
        return Err(nucleotide);
    }
    for n in dna.chars() {
        if !NUCLEOTIDE.contains(&n) {
            return Err(n);
        }
    }
    Ok(dna.chars().filter(|&nuc| nuc != nucleotide).count())
}

pub fn nucleotide_counts(dna: &str) -> Result<HashMap<char, usize>, char> {
    let mut n_count = HashMap::new();
    for nuc in NUCLEOTIDE {
        n_count.insert(nuc, 0);
    }
    for n in dna.chars() {
        if !NUCLEOTIDE.contains(&n) {
            return Err(n);
        }
        let count = n_count.entry(n).or_insert(0);
        *count += 1;
    }
    Ok(n_count)
}