#include "grains.h"
#include <stdint.h>
uint64_t board[64] = {0};

uint64_t square(uint8_t index){
    if(index<1||index>64) return 0;
    if(board[index-1]!=0) return board[index-1];
    if(index==1) board[0]=1;
    else board[index-1]=square(index-1)*2;
    return board[index-1];
}

uint64_t total(void){
    uint64_t sum=0;
    for(int i=0; i<64; i++){
        if(board[i]==0) board[i]=square(i+1);
        sum+=board[i];
    }
    return sum;
}