#ifndef RESISTOR_COLOR_TRIO_H
#define RESISTOR_COLOR_TRIO_H

typedef enum {
    BLACK, BROWN, RED, ORANGE, YELLOW, GREEN, BLUE, VIOLET, GREY, WHITE
} resistor_band_t;

typedef struct {
    int value;
    enum { OHMS, KILOOHMS, MEGAOHMS, GIGAOHMS } unit;
} resistor_value_t;

resistor_value_t color_code(resistor_band_t resistor[]);

#endif
