interface NucleotideCounter {
    [index: string]: number,
}

export function nucleotideCounts(strand: string): NucleotideCounter {
    const counter: NucleotideCounter = {
        'A': 0,
        'C': 0,
        'G': 0,
        'T': 0,
    }

    for (let i = 0; i < strand.length; i++) {
        if (!(strand[i] in counter)) throw new Error('Invalid nucleotide in strand');
        else counter[strand[i]]++;
    }

    return counter;
}
