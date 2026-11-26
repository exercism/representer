#include "anagram.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

// confronta i caratteri per qsort
int compare_chars(const void *a, const void *b){
    return(*(char *)a - *(char *)b);
}

int are_anagrams(const char *str1, const char *str2){
    // determina la lunghezza delle stringhe
    int len1 = strlen(str1);
    int len2 = strlen(str2);

    if(len1 != len2){
        return 0;
    }

    // copia le stringhe per ordinarle
    char *sorted1 = (char *)malloc((len1 + 1) * sizeof(char));
    char *sorted2 = (char *)malloc((len2 + 1) * sizeof(char));
    if(sorted1 == NULL || sorted2 == NULL){
        return 0;
    }
    for(int i = 0; i < len1; i++){
        sorted1[i] = toupper(str1[i]);
        sorted2[i] = toupper(str2[i]);
    }
    sorted1[len1] = '\0';
    sorted2[len2] = '\0';
    if(strcmp(sorted1, sorted2) == 0){
        return 0;
    }
    // ordina le stringhe con qsort
    qsort(sorted1, len1, sizeof(char), compare_chars);
    qsort(sorted2, len2, sizeof(char), compare_chars);

    int result = strcmp(sorted1, sorted2) == 0;

    free(sorted1);
    free(sorted2);

    return result;    
}

void find_anagrams(const char *subject, struct candidates *candidates){
    if(subject == NULL || candidates == NULL || candidates->candidate == NULL || candidates->count == 0){
        return;
    }
    for(size_t i = 0; i < candidates->count; i++){
        if(candidates->candidate[i].is_anagram == UNCHECKED){
            const char *word = candidates->candidate[i].word;
            if(strcmp(candidates->candidate[i].word, subject) == 0){
                candidates->candidate[i].is_anagram = NOT_ANAGRAM;
            }
            else if(are_anagrams(subject, word)){
                candidates->candidate[i].is_anagram = IS_ANAGRAM;
            }
            else{
                candidates->candidate[i].is_anagram = NOT_ANAGRAM;
            }
        }
    }
}
