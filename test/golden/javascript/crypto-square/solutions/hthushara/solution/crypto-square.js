export class Crypto {
	
	constructor(text) {
		this.orig = text;
		this.plain = text.trim().toLowerCase().replace(/\W/g, '');
	}
	get ciphertext() {
		
		let L = Math.sqrt(this.plain.length);
		let R = Math.round(L, 0);
		let C = Math.ceil(L);
		let P = this.plain.padEnd(R * C, ' ');
		return [...Array(C)].map((_,i) => [...P].filter((_,pi) => pi % C === i).join('')).join(' ');

	}
}