#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "diamond.h"

const char BLANK = ' ';

char **make_diamond(const char letter)
{
    int mid = toupper(letter) - 'A';
    int height = mid * 2 + 1;

    char **diamond = calloc(height, sizeof(char *));
    diamond[0] = calloc((mid + 1) * (height + 1), sizeof(char));

    char chr = 'A';
    for (int i = 0; i <= mid; i++, chr++)
    {
        diamond[i] = diamond[0] + (height + 1) * i;
        diamond[height - i - 1] = diamond[i];

        memset(diamond[i], ' ', height);

        diamond[i][mid + i] = chr;
        diamond[i][mid - i] = chr;

        diamond[height - i - 1][mid + i] = chr;
        diamond[height - i - 1][mid - i] = chr;
    }
    return diamond;
}

void free_diamond(char **diamond)
{
    free(diamond[0]);
    free(diamond);
}