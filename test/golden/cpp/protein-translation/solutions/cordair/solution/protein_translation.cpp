#include "protein_translation.h"
#include <cassert>

std::string codonToAminoacid(const std::string& codon) {
    if (codon == "UAA" || codon == "UAG" || codon == "UGA") {
        return "STOP";
    } 
    else if (codon == "AUG") { 
        return "Methionine";
    }
    else if (codon == "UUU" || codon == "UUC") {
        return "Phenylalanine";
    }
    else if (codon == "UUA" || codon == "UUG") {
        return "Leucine";
    }
    else if (codon == "UCU" || codon == "UCC" || codon == "UCA" || codon == "UCG") {          
        return "Serine";
    }
    else if (codon == "UAU" || codon == "UAC") {
        return "Tyrosine";
    }
    else if (codon == "UGU" || codon == "UGC") {
        return "Cysteine";
    }
    else if (codon == "UGG") {
        return "Tryptophan"; 
    } else {
        return "";
    }
}

std::vector<std::string> protein_translation::proteins(const std::string& RNAsequence) {
    
    std::vector<std::string> proteins {};
    
    assert (
        RNAsequence.size() % 3 == 0 && 
        "Total number of nucleotides must be a multiple of 3"
        );
    
    std::string nextAminoacid {};
    for (std::size_t i {0}; i < RNAsequence.size(); i += 3) {
        nextAminoacid = codonToAminoacid(RNAsequence.substr(i, 3));
        if ( nextAminoacid == "STOP") {
            break;
        } else {
            proteins.push_back(nextAminoacid);
        }
    }
    
    return proteins;
}

