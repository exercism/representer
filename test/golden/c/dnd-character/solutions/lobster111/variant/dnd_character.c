#include "dnd_character.h"
#include "stdlib.h"
#include "math.h"
#include "stdio.h"
void bubble_sort(int arr[], int length){
    for (int i=1;i<length;i++){
        for (int j=i;j<length;j++){
            if (arr[j]>arr[j-1]){
                int tmp = arr[j];
                arr[j]=arr[j-1];
                arr[j-1]=tmp;
            }
        }
    }
}
dnd_character_t make_dnd_character(void){
    dnd_character_t c={ability(),ability(),ability(),ability(),ability(),ability(),10};
    c.hitpoints+=modifier(c.constitution);
    return c;

}
int modifier(int score){//score-10/2 rounded down
    return (int)floor((score-10)/2.0F);
}
int ability(void){ // roll 4 numbers, return sum of 3 highest
    const int roll_count = 4;
    int rolls[roll_count];
    for (int i =0;i<roll_count;i++){
        rolls[i] = rand()%6-1;
    }
    bubble_sort(rolls,roll_count);
    int sum = 0;
    for (int i =0;i<roll_count-1;i++){
        sum+=rolls[i];
    }
    return sum;
}