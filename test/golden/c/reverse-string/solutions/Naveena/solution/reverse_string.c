#include "reverse_string.h"

        

          

#include <stdlib.h>

        

          

#include <string.h>

        

          


        

          

char *reverse(const char *phrase)

        

          

{ 

        

          

    int l = strlen(phrase);

        

          

    char *rs;

        

          


        

          

    rs = malloc(l+1);

        

          


        

          

    for (int i=0; i<l;i++)

        

          

    {

        

          

        rs[i]=phrase[l-1-i];

        

          

    }

        

          

    rs[l]='\0';

        

          

        

        

          

    

        

          

    return rs;}    