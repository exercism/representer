// export function toRna() {
//   throw new Error('Remove this statement and implement this function')
// }


export function toRna(dna: string): string {
    if(dna.match(/[^GCTA]/gm)) {
        throw new Error('Invalid input DNA.')
    } else {
        let rna = ''
        dna.split('').forEach(_ => {
            if ('G' === _) {
                rna = `${rna}C`
            } else if ('C' === _) {
                rna = `${rna}G`
            } else if ('T' === _) {
                rna = `${rna}A`
            } else if ('A' === _) {
                rna = `${rna}U`
            }
        })
        return rna
    }
}