const proteinMap = new Map([
    [["AUG"], "Methionine"],
    [["UUU", "UUC"], "Phenylalanine"],
    [["UUA", "UUG"], "Leucine"],
    [["UCU", "UCC", "UCA", "UCG"], "Serine"],
    [["UAU", "UAC"], "Tyrosine"],
    [["UGU", "UGC"], "Cysteine"],
    [["UGG"], "Tryptophan"],
    [["UAA", "UAG", "UGA"], "STOP"],
]);

function proteinIdentification(str: string){
    for(const [stringArray, protein] of proteinMap){
        for(const codon of stringArray){
            if(codon === str)
                return protein
        }
    }
    throw new Error('Invalid codon')
}

export function translate(str: string): Array<string> {
    let proteinSequence: string[] = []
    let beginning: number = 0
    for (let i = 0; i < str.length; i += 3) {
        beginning = i
        let possibleCodon = proteinIdentification(str.substring(beginning, beginning+3))
        if(possibleCodon === "STOP")
            break
        proteinSequence.push(possibleCodon)
    }
    return proteinSequence
}