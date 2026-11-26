type strand = string;

const transcriptor = {
	G: "C",
	C: "G",
	T: "A",
	A: "U", 
};

export function toRna(strand: strand): strand {
	let sequence = "";
	for (let nucleotide of strand)	{
		if (!(nucleotide in transcriptor)) {
			throw new Error("Invalid input DNA.");
		}
		sequence += transcriptor[nucleotide as keyof typeof transcriptor];
	}
	return sequence;
}
