#include "protein_translation.h"

namespace protein_translation {
    const map<string, string> codonToAminoAcid = {
        {"AUG", "Methionine"},
        {"UUU", "Phenylalanine"},
        {"UUC", "Phenylalanine"},
        {"UUA", "Leucine"},
        {"UUG", "Leucine"},
        {"UCU", "Serine"},
        {"UCC", "Serine"},
        {"UCA", "Serine"},
        {"UCG", "Serine"},
        {"UAU", "Tyrosine"},
        {"UAC", "Tyrosine"},
        {"UGU", "Cysteine"},
        {"UGC", "Cysteine"},
        {"UGG", "Tryptophan"},
        {"UAA", "STOP"},
        {"UAG", "STOP"},
        {"UGA", "STOP"}
    };

    vector<string> proteins(string rna) {
        vector<string> result;

        for (size_t i = 0; i < rna.length(); i += 3) {
            const string codon = rna.substr(i, 3);
            if (const auto& it = codonToAminoAcid.find(codon); it != codonToAminoAcid.end()) {
                if (it->second == "STOP") {
                    break;
                }
                result.push_back(it->second);
            }
        }

        return result;
    }
}  // namespace protein_translation
