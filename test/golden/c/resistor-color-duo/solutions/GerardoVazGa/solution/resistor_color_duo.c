#include "resistor_color_duo.h"
#include "stddef.h"
int color_code(resistor_band_t *resisten){
    if(resisten == NULL){
        return -1;
    }

    return (resisten[0] * 10) + resisten[1];
}