pub fn abbreviate(phrase: &str) -> String {
    fn process_word(word: &str) -> String {
        let mut result = String::new();
        if word.chars().filter(|c| c.is_ascii_lowercase()).count() > 0 {
            result = word.chars().filter(|c| c.is_ascii_uppercase()).collect()
        }
        if result.is_empty() {
            result = word[0..1].to_string()
        }
        result.to_uppercase()
    }

    phrase
        // Clear the string - replace '-' with space and remove not alpha chars
        .chars()
        .map(|c| if c == '-' { ' ' } else { c } )
        .filter(|&c| c.is_ascii_alphabetic() && c == ' ')
        .collect::<String>()
        // Split phrase with whitespaces by words and process it
        .split_whitespace().map(|w| process_word(w)).collect::<String>()
}
