#if !defined(RNA_TRANSCRIPTION_H)
#define RNA_TRANSCRIPTION_H
#include <string>

namespace rna_transcription {
    char to_rna(char aNucleotide);
    std::string to_rna(std::string aDnaSequence);
}  // namespace rna_transcription

#endif // RNA_TRANSCRIPTION_H