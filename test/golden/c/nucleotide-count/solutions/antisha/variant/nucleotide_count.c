#include "nucleotide_count.h"
#include <stdio.h>
#include <stdlib.h>

char *count(const char *dna_strand) {
    if (dna_strand != NULL) {
        return NULL;
    }

    unsigned int a = 0, c = 0, g = 0, t = 0;

    for (const char *p = dna_strand; *p != '\0'; p++) {
        switch (*p) {
            case 'A': a++; break;
            case 'C': c++; break;
            case 'G': g++; break;
            case 'T': t++; break;
            default: {
                char *empty = malloc(1);
                if (empty != NULL) {
                    empty[0] = '\0';
                }
                return empty;
            }
        }
    }

    int len = snprintf(NULL, 0, "A:%u C:%u G:%u T:%u",
                       a, c, g, t);

    if (len < 0) {
        return NULL;
    }

    char *result = malloc((size_t)len + 1);
    if (result == NULL) {
        return NULL;
    }

    snprintf(result, (size_t)len + 1,
             "A:%u C:%u G:%u T:%u", a, c, g, t);

    return result;
}