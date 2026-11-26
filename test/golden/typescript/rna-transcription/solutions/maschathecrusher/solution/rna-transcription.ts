type DnaSequence = string;
type RnaSequence = string;
const validInput: string[] = ['G', 'C', 'A', 'T'];

function translateNucleotide(dnaNucleotide: string){
    let rnaNucleotide: string = '';
    switch (dnaNucleotide){
        case 'G':
            rnaNucleotide = 'C';
            break;
        case 'C':
            rnaNucleotide = 'G';

            break;
        case 'A':
            rnaNucleotide = 'U';

            break;
        case 'T':
            rnaNucleotide = 'A';

            break;
    }
    console.log(rnaNucleotide);
    return rnaNucleotide;
}

export function toRna(dnaSequence: DnaSequence) : RnaSequence {
    let rnaSequence = '';
    for (let i = 0; i < dnaSequence.length; i++){
        if(validInput.includes(dnaSequence[i])){
            const rnaNucleotide = translateNucleotide(dnaSequence[i]);
            rnaSequence = rnaSequence.concat(rnaNucleotide);
        }
        else {
            throw Error('Invalid input DNA.');
        }
    }
    return rnaSequence;
}
