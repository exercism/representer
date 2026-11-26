#include "sublist.h"

namespace sublist {
bool compareLists(const std::vector<int>& a, const std::vector<int>& b, std::size_t bStart) {
    	for (std::size_t i = 0; i < a.size(); i++) {
    		if (a[i] != b[i + bStart]) {
    			return false;
    		}
    	}
    	return true;
    }
    List_comparison sublist(const std::vector<int>& a, const std::vector<int>& b) {
        std::size_t a_size = a.size();
        std::size_t b_size = b.size();
        
        if (a_size == b_size) {
            if (compareLists(a, b, 0)) {
                return List_comparison::equal;
            } else {
                return List_comparison::unequal;
            }
        } else if (a_size < b_size) {
            for (std::size_t i = 0; i <= b_size - a_size; i++) {
                if (compareLists(a, b, i)) {
                    return List_comparison::sublist;
                }
            }
            return List_comparison::unequal;
        } else {
            for (std::size_t i = 0; i <= a_size - b_size; i++) {
                if (compareLists(b, a, i)) {
                    return List_comparison::superlist;
                }
            }
            return List_comparison::unequal;
        }
    }
}  // namespace sublist
