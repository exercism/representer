pub fn reply(message: &str) -> &str {
    match message.trim() {
        "" => "Fine. Be that way!",
        msg if msg != msg.to_uppercase() && msg != msg.to_lowercase() => {
            if msg.ends_with('?') {
                "Calm down, I know what I'm doing!"
            } else {
                "Whoa, chill out!"
            }
        },
        msg if msg.ends_with('?') => "Sure.",
        _ => "Whatever."
    }
}
