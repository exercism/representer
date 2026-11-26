#include "gigasecond.h"

namespace gigasecond {
    ptime   advance(ptime lifetime) {
        return lifetime + seconds(1000000000);
    }
}