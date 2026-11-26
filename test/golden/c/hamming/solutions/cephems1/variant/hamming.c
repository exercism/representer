#include "hamming.h"
#include <stddef.h>
#include <string.h>

int compute(const char *lhs, const char *rhs){
    int length = strlen(lhs);
    if (length != (int)strlen(rhs))
        return -1;
    size_t result = 0;
    while(--length > 0){
        if (lhs[length] != rhs[length])
            result++;
    }
    return result;
}