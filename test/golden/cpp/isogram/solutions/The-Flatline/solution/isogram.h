#if !defined(ISOGRAM_H)
#define ISOGRAM_H
#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

namespace isogram {
void Remove_Spaces_Dashes(string& input);
bool is_isogram(string input);
}  // namespace isogram

#endif // ISOGRAM_H