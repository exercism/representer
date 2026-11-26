use std::iter::once;

pub fn build_proverb(list: &[&str]) -> String {
    if list.is_empty() {
        return "".to_owned()
    }

    match list.first() {
        None => String::new(),
        Some(first_word) => list.windows(2)
            .map(|pair| format!("For want of a {} the {} was lost.\n", pair[0], pair[2]))
            .chain(once(format!("And all for the want of a {}.", first_word)))
            .collect()
    }
}
