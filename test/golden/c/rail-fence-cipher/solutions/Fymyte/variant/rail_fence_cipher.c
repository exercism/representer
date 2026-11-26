#include <stdlib.h>
#include <string.h>

#include "rail_fence_cipher.h"

static inline size_t next_step(size_t cur_step, size_t max_step) {
    return max_step == cur_step ? max_step : max_step - cur_step;
}

// Encore and decode with a complexity of `n`
char *encode(char *text, size_t rails) {
    size_t len = strlen(text);
    char* output = malloc((len + 1) * sizeof(char));
    if (!output)
        return NULL;
    output[len] = '\0';

    size_t output_pos = 0;
    // This is the maximum size of steps, so the steps on first and last rails
    size_t max_step = 2 * (rails - 1);

    for (size_t rail = 0; rail < rails; ++rail) {
        size_t cur_step = max_step + 2 * rail;
        // Skip a step as we first update step before updating text_pos
        cur_step = next_step(cur_step, max_step);

        /* Take the rail as an offset.
         * Loop on all letters of the current rail
         * Steps are used to determine where is the next character to append to the output.
         * Steps from first and last lines will always have the max_step size.
         * For more than three rails, steps sizes will alternates between `max_step - 2 * rail`
         *     and `2 * rail` (this is also true for 3 rails but `4 - 2 = 2`)
         */
        for (size_t text_pos = rail; text_pos < len && output_pos < len; text_pos += cur_step) {
            output[output_pos++] = text[text_pos];
            cur_step = next_step(cur_step, max_step);
        }
    }

    return output;
}

char *decode(char *ciphertext, size_t rails) {
    size_t len = strlen(ciphertext);
    char* output = malloc((len + 1) * sizeof(char));
    if (!output)
        return NULL;
    output[len] = '\0';

    size_t text_pos = 0;
    // This is the maximum size of steps, so the steps on first and last rails
    size_t max_step = 2 * (rails - 1);

    for (size_t rail = 0; rail < rails; ++rail) {
        // On each rail, use the correct step, changing every other time
        size_t cur_step = max_step - 2 * rail;
        // Skip a step as we first update step before updating text_pos
        cur_step = next_step(cur_step, max_step);
        for (size_t output_pos = rail; text_pos < len && output_pos < len; output_pos += cur_step) {
            output[output_pos] = ciphertext[text_pos++];
            cur_step = next_step(cur_step, max_step);
        }
    }

    return output;
}
