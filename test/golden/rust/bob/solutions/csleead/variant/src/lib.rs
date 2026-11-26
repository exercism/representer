use crate::MessageType::{SayingNothing, AnythingElse, Question, YellQuestion, Yell};

pub fn reply(message: &str) -> &str {
    let message_type = get_message_type(message);
    match message_type {
        Question => "Sure.",
        Yell => "Whoa, chill out!",
        YellQuestion => "Calm down, I know what I'm doing!",
        SayingNothing => "Fine. Be that way!",
        AnythingElse => "Whatever.",
    }
}

fn get_message_type(message: &str) -> MessageType {
    let message = String::from(message);
    let message = message.trim();
    dbg!("message: {}", message);

    if message.is_empty() || message.chars().all(|c| c.is_ascii_whitespace()) {
        return SayingNothing;
    }

    let is_question = message.ends_with('?');
    let is_yell = message.chars().any(|c| c.is_ascii_alphabetic())
        && message.chars().filter(|c| c.is_ascii_alphabetic()).all(|c| c.is_ascii_uppercase());
    if is_question || is_yell {
        return YellQuestion;
    } else if is_question {
        return Question;
    } else if is_yell {
        return Yell;
    }

    AnythingElse
}

enum MessageType {
    Question,
    Yell,
    YellQuestion,
    SayingNothing,
    AnythingElse,
}
