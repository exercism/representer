export class Crypto {
  plainText: string;

  constructor(plainText: string) {
    this.plainText = plainText;
  }

  get ciphertext(): string {
    let normalizedText = this.plainText.toLowerCase().replace(/\W/gi, "");
    const length = Math.ceil(Math.sqrt(normalizedText.length));

    let rows: string[] = [];
    for (let i = 0; i < normalizedText.length; i += length) {
      rows.push(normalizedText.substring(i, i + length).padEnd(length, " "));
    }

    return Array.from({ length }, (_, col) =>
      rows.map((row) => row[col]).join("")
    ).join(" ");
  }
}
