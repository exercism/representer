const TRANSCRIPTION_MAP = {
    "G": "C",
    "C": "G",
    "T": "A",
    "A": "U"
};

export const toRna = (dnaStrand) => {
    return Array.from(dnaStrand, nucleotide => TRANSCRIPTION_MAP[nucleotide])
        .join('');
};
