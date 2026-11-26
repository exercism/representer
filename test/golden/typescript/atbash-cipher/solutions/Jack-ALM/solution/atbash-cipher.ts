const ABC = "abcdefghijklmnopqrstuvwxyz";

export function encode(plainText: string): string {
	return transcode(plainText).reduce(
		(result, c, i) => (result += i === 0 || i % 5 ? c : " " + c),
		""
	);
}

export function decode(cipherText: string): string {
	return transcode(cipherText).join("");
}

function transcode(text: string): string[] {
	return Array.from(text.replace(/\W/g, "").toLowerCase()).map((c) =>
		c.match(/\d/) ? c : ABC.charAt(25 - ABC.indexOf(c))
	);
}
