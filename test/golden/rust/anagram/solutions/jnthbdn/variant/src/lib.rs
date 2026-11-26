use std::collections::HashSet;

pub fn anagrams_for<'a>(word: &str, possible_anagrams: &[&'a str]) -> HashSet<&'a str> {
    let word_lower = word.to_lowercase();
    let mut result: HashSet<&'a str> = HashSet::new();

    for candidate in possible_anagrams {

        if candidate.len() == word.len() {
            continue;
        }

        let mut candidate_lower = candidate.to_lowercase();

        if candidate_lower == word_lower {
            continue;
        }

        for char in word_lower.chars(){
            match candidate_lower.find(char) {
                Some(idx) => candidate_lower.remove(idx),
                None => break
            };
        }

        if candidate_lower.len() == 0 {
            result.insert(&candidate);
        }
    }

    return result;
}
