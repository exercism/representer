#include "resistor_color_trio.h"

resistor_value_t color_code(resistor_band_t color_bands[]) {
    int value = (color_bands[0] * 10 + color_bands[1]);
    for (int i = 0; i < (int)(color_bands[2] % 3); i++) value *= 10;
    int unit = color_bands[2] / 3;
    while (value >= 1000) {
        value /= 1000;
        unit++;
    }
    return (resistor_value_t){value, unit};
}
