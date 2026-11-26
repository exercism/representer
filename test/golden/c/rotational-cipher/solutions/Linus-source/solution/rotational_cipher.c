#include "rotational_cipher.h"
#include <string.h>
#include <stdlib.h>

char *rotate(const char *text, int shift_key){
    int length = strlen(text);
    char *output = malloc(sizeof(char)*(length+1));
    output[length] = '\0';
    for(int i=0; i<length; i++){
        int sub;
        if(text[i]>='a' && text[i]<='z') sub = 'a';
        else if(text[i]>='A' && text[i]<='Z') sub = 'A'; 
        else {output[i] = text[i]; continue;}
        output[i] = sub + ((text[i] - sub + shift_key)%26);
    }
    return output;
}