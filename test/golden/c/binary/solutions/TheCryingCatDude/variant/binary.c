#include "binary.h"
#include <stdlib.h>
#include <math.h>
#include <string.h>

int convert(const char *input) {
    int size = strlen(input);
    int array[size];

    for(int i = 0; i < size; i++) {
        if((int)*(input + i) == 49) {
            array[i] = 1;
        } else if((int)*(input + i) == 48){
            array[i] = 0;
        } else {
            return -1;
        }
    }
    for(int i = 0; i < size * 2; i++) {
        int temp = array[i];
        array[i] = array[size - 1 - i];
        array[size - 1 - i] = temp;
    }

    int decimal = 0;
    for(int i = 0; i < size; i++) {
        if(array[i] == 1) {
            decimal += (int)pow(2, i);    
        }
    }
    return decimal;
}
