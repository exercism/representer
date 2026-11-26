#include "protein_translation.h"
#include <string.h>

protein_t protein(const char *const rna) {
    size_t len = strlen(rna);
    protein_t pr;
    pr.valid = true;
    pr.count = 0;
    for (size_t i  = 0; i < len; i+=3) {
        if (rna[i] ==  'A' && rna[i + 1] ==  'U' && rna[i + 2] ==  'G') {
            pr.valid = true;
            pr.amino_acids[pr.count] = Methionine;
            pr.count++;
        } else if (rna[i] ==  'U' && rna[i + 1] ==  'U' && (rna[i + 2] ==  'U' || rna[i + 2] ==  'C')) {
            pr.valid = true;
            pr.amino_acids[pr.count] = Phenylalanine;
            pr.count++;
        } else if (rna[i] ==  'U' && rna[i + 1] ==  'U' && (rna[i + 2] ==  'A' || rna[i + 2] ==  'G')) {
            pr.valid = true;
            pr.amino_acids[pr.count] = Leucine;
            pr.count++;
        } else if (rna[i] ==  'U' && rna[i + 1] ==  'C' && (rna[i + 2] ==  'U' || rna[i + 2] ==  'C'
                                                            || rna[i + 2] ==  'A' || rna[i + 2] ==  'G')) {
            pr.valid = true;
            pr.amino_acids[pr.count] = Serine;
            pr.count++;
        } else if (rna[i] ==  'U' && rna[i + 1] ==  'A' && (rna[i + 2] ==  'U' || rna[i + 2] ==  'C')) {
            pr.valid = true;
            pr.amino_acids[pr.count] = Tyrosine;
            pr.count++;
        } else if (rna[i] ==  'U' && rna[i + 1] ==  'G' && (rna[i + 2] ==  'U' || rna[i + 2] ==  'C')) {
            pr.valid = true;
            pr.amino_acids[pr.count] = Cysteine;
            pr.count++;
        } else if (rna[i] ==  'U' && rna[i + 1] ==  'G' && rna[i + 2] ==  'G') {
            pr.valid = true;
            pr.amino_acids[pr.count] = Tryptophan;
            pr.count++;
        }  else if ((rna[i] ==  'U' && rna[i + 1] ==  'A' && (rna[i + 2] ==  'A' || rna[i + 2] ==  'G')) || (rna[i] ==  'U' && rna[i + 1] ==  'G' && rna[i + 2] ==  'A')) {
            pr.valid = true;
            break;
        } else if (len == 0){
            pr.valid = true;
            pr.count = 0;
        } else {
            pr.valid = false;
        }
    }
    return pr;
}







