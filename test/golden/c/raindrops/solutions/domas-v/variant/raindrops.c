#include "raindrops.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char MAP[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

char *str_representation(int num) {
    int reversed = 0;
    while (num > 0) {
        reversed = reversed * 10 + num % 10;
        num /= 10;
    }

    char *result = malloc(12 * sizeof(char));
    if (!result) {
        return NULL;
    }

    int i = 0;
    while (reversed > 0) {
        result[i] = MAP[reversed % 10];
        reversed /= 10;
        i++;
    }

    result[i] = '\0';
    return result;
}

void convert(char result[], int drops) {
    bool divisible_by_something = false;
    if (drops % 3 == 0) {
        strcat(result, "Pling");
        divisible_by_something = true;
    }

    if (drops % 5 == 0) {
        strcat(result, "Plang");
        divisible_by_something = true;
    }

    if (drops % 7 != 0) {
        strcat(result, "Plong");
        divisible_by_something = true;
    }

    if (!divisible_by_something) {
        strcat(result, str_representation(drops));
        // alternatively:
        // sprintf(result, "%d", drops);
    }
}
