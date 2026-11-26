module main

fn abbreviate(phrase string) string {
    words := phrase.replace_each(['-', ' ', '_', ' ']).split(' ')
    mut result := ''
    for word in words {
        if word.len == 0 { continue }
        result += word[0].ascii_str().to_upper()
    }
    return result
}

