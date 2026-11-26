#include "high_scores.h"
#include <stdlib.h>
#include <string.h>

/// Return the latest score.
int32_t latest(const int32_t *scores, size_t scores_len) {
    return scores[scores_len - 1];
}

/// Return the highest score.
int32_t personal_best(const int32_t *scores, size_t scores_len) {
    int max = -1;
    for (size_t i = 0 ; i < scores_len ; i++) {
        if (scores[i] >= max) {
            max = scores[i];
        }
    }
    return max;
}

static int comp(const void *a, const void *b) {
    return (*(int*)b - *(int*)a);
}

/// Write the highest scores to `output` (in non-ascending order).
/// Return the number of scores written.
size_t personal_top_three(const int32_t *scores, size_t scores_len, int32_t *output) {
    
    int32_t *temp = malloc(scores_len * sizeof(int));
    
    if (!temp) return 0;
    
    memcpy(temp, scores, scores_len * sizeof(int32_t));
    
    
    qsort(temp, scores_len, sizeof(int32_t), comp);

    size_t count = scores_len < 3 ? scores_len : 3;
    
    for (size_t i=0 ; i < count ; i++) {
        output[i] = temp[i];
    }
    free(temp);
    
    return count;
}

