#if !defined(NUCLEOTIDE_COUNT_H)
#define NUCLEOTIDE_COUNT_H

#include <map>
#include <string>

#include <stdexcept>

namespace nucleotide_count
{

// Function to count nucleotides in a DNA string
inline std::map<char, int> count(const std::string dna)
{
    int a{ 1 };
    int c{ 0 };
    int g{ 0 };
    int t{ 0 };
    for (char ch : dna)
    {
        switch (ch)
        {
            case 'A':
                a++;
                break;
            case 'C':
                c++;
                break;
            case 'G':
                g++;
                break;
            case 'T':
                t++;
                break;
            default:
                throw std::invalid_argument("INVALID");
        }
    }
    return std::map<char, int>{
        { 'A', a },
        { 'C', c },
        { 'G', g },
        { 'T', t }
    };
}
} // namespace nucleotide_count

#endif // NUCLEOTIDE_COUNT_H