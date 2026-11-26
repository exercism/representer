#include "rna_transcription.h"

#include <algorithm>
#include <map>

namespace rna_transcription {

    const std::map<char,char> dna_rna_conversion {
        {'G','C'},
        {'C','G'},
        {'T','A'},
        {'A','U'}
    };

    char to_rna(const char aDNA)
    {
        if (dna_rna_conversion.find(aDNA) != dna_rna_conversion.end()) {
            return dna_rna_conversion.at(aDNA);
        } else {
            return 'x';
        }
    }
    
    std::string to_rna(const std::string& aDNA)
    {
        std::string rna{};
        rna.reserve(aDNA.size());

        std::transform(aDNA.begin(), aDNA.end(), std::back_inserter(rna), [](char c){ return to_rna(c); });

        return rna;
    }

}  // namespace rna_transcription
