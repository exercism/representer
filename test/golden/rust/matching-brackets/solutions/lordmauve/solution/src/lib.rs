pub fn brackets_are_balanced(string: &str) -> bool {
    let mut stack = Vec::new();
    for c in string.chars() {
        match c {
            '[' => stack.push(']'),
            '{' => stack.push('}'),
            '(' => stack.push(')'),
            ']' | '}' | ')' => match stack.pop() {
                Some(top) if top == c => continue,
                _ => return false,
            },
            _ => continue,
        }
    }

    stack.is_empty()
}
