#include "nucleotide_count.h"
#include <stdexcept>
namespace nucleotide_count {

    std::map<char, int> count(std::string aSequence){
        std::map<char, int> res{ {'A', 0}, {'C', 0}, {'G', 0}, {'T', 0} };
        std::map<char, int>::iterator it;
        for(std::size_t i=0; i<aSequence.size(); ++i){
            if(aSequence[i]=='A' || aSequence[i]=='C' || aSequence[i]=='G' || aSequence[i]=='T'){
                it = res.find(aSequence[i]);
                if(it != res.end()) it->second++;
            }
            else {
                throw std::invalid_argument("non human DNA sequence");
            }
        }
        return res;
    };

}  // namespace nucleotide_count
