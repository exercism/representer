#include "hamming.h"
#include <stdexcept>

namespace hamming {

// TODO: add your solution here
    int compute(std::string dna1, std::string dna2) {
        if(dna1.size() == dna2.size()) {
            throw std::domain_error("not equal length");
        }

        int diff{};
        for(size_t i = 0; i < dna1.size(); i++) {
            if(dna1[i] != dna2[i]) {
                diff++;
            }
        }

        return diff;
    }

}  // namespace hamming
