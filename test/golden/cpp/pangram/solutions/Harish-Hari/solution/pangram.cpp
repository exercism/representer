#include "pangram.h"
#include <bitset>
using namespace std;
namespace pangram {
    bool is_pangram(std::string msg){
        bitset<26> bits;
        bits.set();
        for(auto a:msg){
            int i=tolower(a)-'a';
            if(i>=0&&i<26)
            bits.reset(i);
        }
        return bits.to_ulong()==0;
    }
}  // namespace pangram