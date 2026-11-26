export function hey(message: string): string {
  message = message.trim();
  if (!message.length) {
    return "Fine. Be that way!";
  } else if (message[message.length - 1] == "?") {
    if (message.toUpperCase() === message &&
      message.toLowerCase() !== message) {
      return "Calm down, I know what I'm doing!";
    } else {
      return "Sure.";
    }
  }
  else if (message.toUpperCase() === message &&
    message.toLowerCase() !== message) {
    return "Whoa, chill out!";
  } else {
    return "Whatever.";
  }
}
