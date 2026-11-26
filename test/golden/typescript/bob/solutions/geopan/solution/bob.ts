function isUpperCase(str: string) {
  return /^[^a-z]*$/.test(str) && /[A-Z]/.test(str);
}

export function hey(message: string): string {
  const cleanStr = message.trim();

  const lastChr = cleanStr[cleanStr.length - 1];

  if (cleanStr.length === 0) return "Fine. Be that way!";

  if (isUpperCase(cleanStr)) {
    return lastChr === "?"
      ? "Calm down, I know what I'm doing!"
      : "Whoa, chill out!";
  }

  return lastChr === "?" ? "Sure." : "Whatever.";
}
