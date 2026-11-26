#include "secret_handshake.h"
#include <stdlib.h>

const char **commands(size_t number) {
    const char *actions[] = {
        "wink",
        "double blink",
        "close your eyes",
        "jump"
    };

    // Tüm elemanları NULL ile başlatmak için calloc kullanıyoruz
    const char **result = calloc(5, sizeof(const char *));
    if (result == NULL) {
        return NULL;
    }

    size_t count = 0;
    for (size_t i = 0; i < 4; i++) {
        if (number & (1U << i)) {
            result[count++] = actions[i];
        }
    }

    // 16 biti aktifse diziyi ters çevir
    if (number & 16U) {
        for (size_t i = 0; i < count / 2; i++) {
            const char *temp = result[i];
            result[i] = result[count - 1 - i];
            result[count - 1 - i] = temp;
        }
    }

    return result;
}
