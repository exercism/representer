#include "beer_song.h"

void recite(uint8_t start_bottles, uint8_t take_down, char **song){
    int line_index = 0;

    for (int i = start_bottles; i > start_bottles - take_down; i--) {
        char *line1 = malloc(100);
        char *line2 = malloc(100);

        if (i > 2) {
            snprintf(line1, 100, "%d bottles of beer on the wall, %d bottles of beer.", i, i);
            snprintf(line2, 100, "Take one down and pass it around, %d bottles of beer on the wall.", i - 1);
        } else if (i == 2) {
            snprintf(line1, 100, "2 bottles of beer on the wall, 2 bottles of beer.");
            snprintf(line2, 100, "Take one down and pass it around, 1 bottle of beer on the wall.");
        } else if (i == 1) {
            snprintf(line1, 100, "1 bottle of beer on the wall, 1 bottle of beer.");
            snprintf(line2, 100, "Take it down and pass it around, no more bottles of beer on the wall.");
        } else {
            snprintf(line1, 100, "No more bottles of beer on the wall, no more bottles of beer.");
            snprintf(line2, 100, "Go to the store and buy some more, 99 bottles of beer on the wall.");
        }

        song[line_index++] = line1;
        song[line_index++] = line2;

        if (i != start_bottles - take_down + 1) {
            char *empty = malloc(1);
            strcpy(empty, "");
            song[line_index++] = empty;
        }
    }
}