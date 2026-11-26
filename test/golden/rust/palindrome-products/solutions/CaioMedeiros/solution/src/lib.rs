use std::collections::HashSet;

#[derive(Debug, PartialEq, Eq)]
pub struct Palindrome {
    value: u32,
    factors: HashSet<(u32, u32)>,
}

impl Palindrome {
    pub fn new(value: u32, factors: HashSet<(u32, u32)>) -> Self {
        Palindrome { value, factors }
    }

    pub fn value(&self) -> u32 {
        self.value
    }

    pub fn into_factors(self) -> HashSet<(u32, u32)> {
        self.factors
    }
}

fn is_palindrome(num: u32) -> bool {
    let s = num.to_string();
    s.chars().eq(s.chars().rev())
}

pub fn palindrome_products(min: u32, max: u32) -> Option<(Palindrome, Palindrome)> {
    if min > max {
        return None;
    }

    let mut palindromes = std::collections::BTreeMap::<u32, HashSet<(u32, u32)>>::new();

    for i in min..=max {
        for j in i..=max {
            let prod = i * j;
            if is_palindrome(prod) {
                let entry = palindromes.entry(prod).or_insert_with(HashSet::new);
                // Armazenar fatores ordenados para evitar duplicidade (3,5) e (5,3)
                entry.insert((i.min(j), i.max(j)));
            }
        }
    }

    if palindromes.is_empty() {
        return None;
    }

    let smallest_value = *palindromes.keys().next().unwrap();
    let largest_value = *palindromes.keys().last().unwrap();

    let smallest_pal = Palindrome::new(smallest_value, palindromes.remove(&smallest_value).unwrap());
    let largest_pal = Palindrome::new(largest_value, palindromes.remove(&largest_value).unwrap());

    Some((smallest_pal, largest_pal))
}
