use std::collections::HashMap;

pub fn count(nucleotide: char, dna: &str) -> Result<usize, char> {
    if !is_nucleotide(nucleotide) {
        return Err(nucleotide);
    }

    let mut res = 0;
    for char in dna.chars().into_iter() {
        if is_nucleotide(char) {
            if char == nucleotide {
                res += 1;
            }
        } else {
            return Err(char);
        }
    }

    Ok(res)
}

fn is_nucleotide(c: char) -> bool {
    match c {
        'A' | 'C' | 'G' | 'T' => true,
        _ => false,
    }
}

pub fn nucleotide_counts(dna: &str) -> Result<HashMap<char, usize>, char> {
    let mut res: HashMap<char, usize> = HashMap::new();

    for c in vec!['A', 'C', 'G', 'T'] {
        let r = count(c, dna);
        if let Ok(cnt) = r {
            res.insert(c, cnt);
        } else if let Err(e) = r {
            return Err(e);
        }
    }

    Ok(res)
}