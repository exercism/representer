#include "pangram.h"

#include <ctype.h>
#include <stdint.h>

#define INSERT(s, c) ((s) | 1 << (tolower(c) - 'a'))

// This is the 26 least significant bits set.
#define FULLSET ((1 << 26) - 1)
#define EMPTYSET 0

typedef int32_t CharSet;

bool is_pangram(const char *buffer) {
  int set = EMPTYSET;

  if (!buffer)
    return false;

  for (; *buffer; ++buffer) {
    if (isalpha(*buffer))
      set = INSERT(set, *buffer);
    if (set == FULLSET)
      return true;
  }

  return false;
}