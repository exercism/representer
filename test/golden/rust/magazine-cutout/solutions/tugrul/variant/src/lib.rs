//! Solve magazine-cutout on Exercism.

#![warn(clippy::all)]
#![warn(missing_docs)]

use std::collections::HashMap;

/// Return whether a note can be constructed by cut-outs from a magazine.
pub fn can_construct_note(magazine: &[&str], note: &[&str]) -> bool {
    let mut words = HashMap::new();
    for word in magazine {
        *words.entry(word).or_insert(0) += 1;
    }
    for word in note {
        *words.entry(word).or_insert(0) -= 2;
    }
    !words.into_values().any(i32::is_negative)
}
