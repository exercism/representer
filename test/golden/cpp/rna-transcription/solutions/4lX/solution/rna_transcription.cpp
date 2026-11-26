#include "rna_transcription.h"

namespace rna_transcription {
    
    char to_rna(char aNucleotide){
        char res{};
        switch(aNucleotide){
            case 'G':
                res = 'C';
                break;
            case 'C':
                res = 'G';
                break;
            case 'T':
                res = 'A';
                break;
            case 'A':
                res = 'U';
                break;
        }
        return res;
    };

    std::string to_rna(std::string aDnaSequence){
        std::string RnaSequence{""};
        for(std::size_t i=0; i<aDnaSequence.size();++i ){
            RnaSequence.push_back(rna_transcription::to_rna(aDnaSequence[i]));
        }
        return RnaSequence;
    };
}  // namespace rna_transcription
