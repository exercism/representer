#include "space_age.h"

namespace space_age {

  space_age::space_age(long seconds):_seconds(seconds) {
  }
  long space_age::seconds() const {
    return _seconds;
  }
}  // namespace space_age
