#include "leap.h"

namespace a {

bool b(int c) {
    auto d = [=](int e) { return c % e == 0; };
    return d(4) && (!d(100) || d(400));
}

}  // namespace a
