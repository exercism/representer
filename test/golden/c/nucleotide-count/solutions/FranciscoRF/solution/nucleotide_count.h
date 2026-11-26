#ifndef NUCLEOTIDE_COUNT_H
#define NUCLEOTIDE_COUNT_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define MAX_RESULT_LENGTH (24)

enum {
    A = 0,
    C,
    G,
    T,
    N_DNA_NUCLEOTIDES
};

char *count(const char *dna_strand);

#endif
