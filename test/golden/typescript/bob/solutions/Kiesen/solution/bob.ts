export function hey(message: string): string {
  const trimmedMessage = message.trim();

  if (trimmedMessage == "") return "Fine. Be that way!";
  
  const isQuestion = trimmedMessage.endsWith('?');
  const isYelling = trimmedMessage.match(/[A-Z]/) && trimmedMessage === trimmedMessage.toUpperCase();

  if (isQuestion && isYelling) {
    return 'Calm down, I know what I\'m doing!';
  } else if (isQuestion) {
    return 'Sure.';
  } else if (isYelling) {
    return 'Whoa, chill out!';
  } else {
    return 'Whatever.';
  }
}
