#include "high_scores.h"
#include <stdio.h>

int32_t latest(const int32_t *scores, size_t scores_len)
{
    return scores[scores_len - 1];
}

int32_t personal_best(const int32_t *scores, size_t scores_len)
{
    int32_t result = 0;
    for (size_t i = 0; i < scores_len; i++)
    {
        if (scores[i] >= result) {
            result = scores[i];
        }
    }
    return result;
}

static size_t insert(const int32_t input, int pos, int32_t *output)
{
    if (pos > 2)
    {
        return pos;
    }
    int32_t existing = output[pos];
    if (input > existing)
    {
        output[pos] = input;
        return insert(existing, pos + 1, output); 
    }
    if (existing == 0)
    {
        return pos;
    }
    return insert(input, pos + 1, output); 
}

size_t personal_top_three(const int32_t *scores, size_t scores_len, int32_t *output)
{
    size_t result = 0;
    output[0] = 0;
    output[1] = 0;
    output[2] = 0;
    for (size_t i = 0; i < scores_len; i++)
    {
        size_t final_pos = insert(scores[i], 0, output);
        if (final_pos > result)
        {
            result = final_pos;
        }
    }
    return result;
}
