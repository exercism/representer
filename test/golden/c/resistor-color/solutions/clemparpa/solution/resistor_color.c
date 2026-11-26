#include "resistor_color.h"


unsigned int color_code(resistor_band_t band){
    return (unsigned int)band;
}

resistor_band_t * colors(void){
    static resistor_band_t colores[] = { BLACK, BROWN, RED, ORANGE, YELLOW, GREEN, BLUE, VIOLET, GREY, WHITE };
    return colores;
}
