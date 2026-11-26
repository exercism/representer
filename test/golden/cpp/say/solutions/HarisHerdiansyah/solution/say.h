#if !defined(SAY_H)
#define SAY_H
#include <string>
#include <vector>
using namespace std;

namespace say {
  string dictionary(string key, int num);
  string to_word(int num);
  vector<string> group_num_in_words(unsigned long long int num);
  string in_english(unsigned long long int num);
}  // namespace say

#endif // SAY_H