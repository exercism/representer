#include "hamming.h"
#include <stdexcept>

namespace hamming {
    int compute(string dna_1, string dna_2) {
        int difference = 0;
        
        if (dna_1.length() != dna_2.length()) {
            throw domain_error("DNA-s must be of the same length!");
        }

        for(long unsigned int i = 0; i < dna_1.length(); i++) {
            if(dna_1[i] != dna_2[i]) {
                difference += 1;
            }
        }
        
        return difference;
    }
}  // namespace hamming
