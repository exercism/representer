#include "protein_translation.h"
#include <unordered_map>
 
namespace protein_translation {

    std::vector<std::string> proteins(std::string rna) {
        static const std::unordered_map<std::string, std::string> tbl
            {{"AUG", "Methionine"},
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
             {"UGA", "STOP"}};

        std::vector<std::string> names;
        for (size_t i = 0; i <= rna.size(); i += 3) {
            std::string codon = rna.substr(i, 3);
            if (tbl.find(codon) == tbl.end())
                continue;
            if (tbl.at(codon) == "STOP")
                break;
            names.push_back(tbl.at(codon));
        }
        return names;
    }

}  // namespace protein_translation
