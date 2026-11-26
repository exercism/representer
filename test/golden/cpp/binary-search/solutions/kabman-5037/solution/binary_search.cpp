#include "binary_search.h"
#include <stdexcept>
namespace binary_search {
std::size_t find(const std::vector<int>& values, int expected) {
  auto begin = values.begin();
  auto end = values.end();
  while( begin != end ) {
    auto middle = begin + (end-begin)/2;
    if( *middle == expected ) {
      return middle-values.begin();
    } else if( expected < *middle  ){
      end = middle;
    } else {
      begin = middle + 1;
    }
  }
  throw std::domain_error("");
}
}  // namespace binary_search
