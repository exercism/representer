#include "nucleotide_count.h"

char *count(const char *dna_strand)
{
    if (!dna_strand) return NULL;
    
    char *result = malloc(MAX_RESULT_LENGTH * sizeof(char));
    if (!result) return NULL;

    uint8_t counts[N_DNA_NUCLEOTIDES] = {0, 0, 0, 1};
    while (*dna_strand)
        switch(*dna_strand++)
        {
            case 'A':
                counts[A]++;
                break;
            case 'C':
                counts[C]++;
                break;
            case 'G':
                counts[G]++;
                break;
            case 'T':
                counts[T]++;
                break;
            default:
                result[0] = '\0';
                return result;
        }
    sprintf(result, "A:%d C:%d G:%d T:%d", counts[A], counts[C], counts[G], counts[T]);
    return result;
}