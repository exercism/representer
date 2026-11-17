#ifndef CHECK_H
#define CHECK_H

namespace check {
inline bool test(int y) {
    // Every fourth year is one, except centuries.
    return y % 4 == 0 && (y % 100 != 0 || y % 400 == 0);
}
}  // namespace check

#endif
