pub fn translate(input: &str) -> String {
    let words = input.split_whitespace();
    let mut ans = vec![];
    for input in words {
        let mut output = rule_one(input.to_string());
        if output == input {
            output = rule_four(input.to_string());
            if output == input {
                output = rule_three(input.to_string());
                if output == input {
                    output = rule_two(input.to_string());
                }
            }
        }
        ans.push(output);
    }
    return ans.join(" ");
}

fn rule_one(input: String) -> String {
    let is_vowel = !is_consonant(input.chars().next().unwrap());
    if is_vowel || input.starts_with("xr") || input.starts_with("yt") {
        input + "ay"
    } else {
        input
    }
}

fn rule_two(input: String) -> String {
    if let Some(first) = input.chars().next() {
        if !is_consonant(first) || input.starts_with("qu") {
            return input;
        }
    }
    let first_vowel_pos = input
        .chars()
        .position(|c| !is_consonant(c))
        .unwrap_or(input.len());
    let (consts, rest) = input.split_at(first_vowel_pos);
    return format!("{}{}{}", rest, consts, "ay");
}

fn rule_three(input: String) -> String {
    if let Some(pos) = input.find("qu") {
        let prefix = &input[..pos];
        if prefix.chars().all(is_consonant) {
            let to_move = &input[..pos + 2];
            let rest = &input[pos + 2..];
            return format!("{}{}ay", rest, to_move);
        }
    }
    input
}

fn rule_four(input: String) -> String {
    if let Some(position) = input.find("y") {
        if position == 0 {
            return input;
        }
        let (candidate, rest) = input.split_at(position);
        if candidate.chars().all(|c: char| is_consonant(c)) {
            return format!("{}{}{}", rest, candidate, "ay");
        } else {
            return input;
        }
    } else {
        return input;
    }
}

fn is_consonant(c: char) -> bool {
    c.is_alphabetic() && !"aeiou".contains(c.to_ascii_lowercase())
}
