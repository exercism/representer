#include "rna_transcription.h"
#include <algorithm>
namespace rna_transcription {
char to_rna(char dna) {
  switch (dna) {
  case 'G':
    return 'C';
    break;
  case 'C':
    return 'G';
    break;
  case 'T':
    return 'A';
    break;
  case 'A':
    return 'U';
    break;
  }
  return '_';
}
std::string to_rna(std::string dna) {
  std::transform(std::begin(dna), std::end(dna), std::begin(dna),
                 [](char c) { return to_rna(c); });
  return dna;
}
} // namespace rna_transcription
