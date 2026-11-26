#include "atbash_cipher.h"
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

static char atbash_char(char c)
{
    return (char)('a' + ('z' - c));
}

char *atbash_encode(const char *input)
{
    size_t len = strlen(input);

    /* once sadece harf/rakamlari say (bosluk/noktalama haric) */
    size_t clean_count = 0;
    for (size_t i = 0; i < len; i++) {
        if (isalnum((unsigned char)input[i])) {
            clean_count++;
        }
    }

    /* her 5 karakterden sonra (son grup haric) bir bosluk eklenecek */
    size_t group_count = (clean_count == 0) ? 0 : (clean_count - 1) / 5;
    size_t out_len = clean_count + group_count;

    char *result = malloc(out_len + 1);
    size_t out = 0;
    size_t letters_in_group = 0;

    for (size_t i = 0; i < len; i++) {
        char c = input[i];
        if (!isalnum((unsigned char)c)) {
            continue;
        }

        if (letters_in_group == 5) {
            result[out++] = ' ';
            letters_in_group = 0;
        }

        if (isalpha((unsigned char)c)) {
            result[out++] = atbash_char((char)tolower((unsigned char)c));
        } else {
            result[out++] = c; /* rakam degismeden kalir */
        }
        letters_in_group++;
    }

    result[out] = '\0';
    return result;
}

char *atbash_decode(const char *input)
{
    size_t len = strlen(input);
    char *result = malloc(len + 1); /* bosluklar cikacagi icin bu ust sinir yeterli */
    size_t out = 0;

    for (size_t i = 0; i < len; i++) {
        char c = input[i];
        if (!isalnum((unsigned char)c)) {
            continue; /* gruplama bosluklarini atla */
        }

        if (isalpha((unsigned char)c)) {
            result[out++] = atbash_char((char)tolower((unsigned char)c));
        } else {
            result[out++] = c;
        }
    }

    result[out] = '\0';
    return result;
}