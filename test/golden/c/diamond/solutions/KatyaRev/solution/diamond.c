#include "diamond.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
char **make_diamond(const char letter){
    int rows=(int)(letter-'A'+1)*2-1;
    int let=(int)(letter-'A');
    char **diamond=malloc(sizeof(char *)*rows);
    for(int i=0;i<rows;i++){
        diamond[i]=malloc(sizeof(char *)*(rows+1));
        memset(diamond[i], ' ', rows);
        diamond[i][rows]='\0';
        for(int j=0;j<rows;j++){
            for(int k=0;k<=let;k++)
                if((i == k && j == let - k)
                 ||(i == rows - 1 - k && j == let - k)
                 ||(i == k && j == let + k )
                 ||(i == rows - 1 - k && j == let + k))
                    diamond[i][j]=k+'A';
        }
    }
    return diamond;
}
void free_diamond(char **diamond){
    free(diamond);
}