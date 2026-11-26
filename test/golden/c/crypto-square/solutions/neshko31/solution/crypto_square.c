#include "crypto_square.h"

char *ciphertext(const char *input) {
    if (!input || *input == '\0') 
        return calloc(1, sizeof(char));

    char *normalized_text = (char *)calloc(strlen(input) + 1, sizeof(char));
    if (!normalized_text) return NULL;

    int nt_count = 0;
    for (unsigned i = 0; i < strlen(input); i++) {
        if (isalnum(input[i])) {
            normalized_text[nt_count++] = tolower(input[i]);
        }
    }

    if (nt_count == 0) {
        free(normalized_text);
        return calloc(1, sizeof(char));
    }

    int r = 1, c = 1;
    while (1) {
        if (r * c >= nt_count) {
            break;
        }
        else if (r * (c + 1) >= nt_count) {
            c++;
            break;
        }
        r++; c++;
    }

    char *temp = realloc(normalized_text, r * c + 1);
    if (!temp) {
        free(normalized_text);
        return NULL;
    }
    normalized_text = temp;
    
    for (int i = nt_count; i < r * c; i++) {
        normalized_text[i] = ' ';
        nt_count++;
    }
    normalized_text[r * c] = '\0';

    char *coded_message = (char *)calloc((r * c + c), sizeof(char));
    if (!coded_message) {
        free(normalized_text);
        return NULL;
    }

    int cm_count = 0;
    for (int i = 0; i < c; i++) {
        for (int j = i; j < nt_count; j+=c) {
            coded_message[cm_count++] = normalized_text[j];
        }
        if (i + 1 < c) {
            coded_message[cm_count++] = ' ';
        }
    }
    free(normalized_text);
    
    return coded_message;
}