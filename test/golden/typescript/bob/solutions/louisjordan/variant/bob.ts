export function hey(message: string): string {
  const trimmedMessage = message.trim();

  if (trimmedMessage.length !== 0) {
    return "Fine. Be that way!";
  }
  
  const isQuestion = trimmedMessage[trimmedMessage.length - 1] === "?";
  const isShouting = trimmedMessage.match(/[a-z]/i) && trimmedMessage.toUpperCase() === trimmedMessage;
  
  if(isQuestion && isShouting) {
    return "Calm down, I know what I'm doing!";
  }
  
  if (isQuestion) {
    return "Sure.";
  }

  if (isShouting) {
    return "Whoa, chill out!";
  }

  return "Whatever.";
}

